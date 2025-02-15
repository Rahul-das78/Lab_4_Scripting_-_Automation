import os
import numpy as np
import pandas as pd1
import shutil
import csv

models = os.listdir("Modules") #modules list as array 
print(models)

top_modules = []
for mod in models:
    if (mod[:3]=='top'):
        top_modules.append(mod[:-2])
    print(mod)
print(top_modules)

os.system("vivado -mode batch -source tcl_create.tcl")   #creating new project

for mod1 in models:
    os.system("vivado -mode batch -source  tcl_add.tcl -tclargs {}".format(mod1))

if os.path.exists("results"):
    shutil.rmtree("results")
os.mkdir("results")

for filename in models:
    folder_path = "results/" + filename[:-2]
    
    try:
        # Create the folder in results
        os.mkdir(folder_path)
        
        # Run the Vivado synthesis command and capture the return code
        return_code = os.system("vivado -mode batch -source tcl_run.tcl -tclargs {}".format(filename))
        
        # Check if Vivado returned a non-zero exit code (indicating failure)
        if return_code != 0:
            raise Exception
        
        print("{} reported".format(filename))

    except:
        print(filename+ " is not Synthesizable")
        # Delete the folder if it exists
        if os.path.exists(folder_path):
            shutil.rmtree(folder_path)
	continue
		
data_files = os.listdir("results")  
print(data_files)

file_types = ['power.txt','timing.txt','utilization.txt']

req_data = ['Total On-Chip Power','Data Path Delay','Slice LUTs']

Power = []
Delay = []
LUTs = []
for data in data_files :
    for file in file_types: 
		with open("results/{}/{}".format(data,file),'r') as File:
             		content = File.read()

        	words = content.split('\n')   

        	for req_word in words:
            		if file_types[0] in file:
                		if req_data[0] in req_word:
                    			pwr = float(req_word.split()[6])
                    			print(pwr)
                    			Power.append(pwr)
  

        	for req_word in words:
            		if file_types[1] in file:
                		if req_data[1] in req_word:
                    			delay = float(req_word.split()[3][:-2])
                    			print(delay)
                    			Delay.append(delay)
 		for req_word in words:
            		if file_types[2] in file:
                		if req_data[2] in req_word:
                    			luts = float(req_word.split()[4])
                    			print(luts) 
                    			LUTs.append(luts) 
                    			print("_____") 


Final_results = [Power,Delay,LUTs]

row_name = ['Power','Delay','LUTs']


if os.path.exists("Final_results.csv"):
	os.remove("Final_results.csv")

df = pd1.DataFrame(Final_results, index = row_name)
df.columns = data_files



df.to_csv('Final_results.csv', index = row_name)
print(df)    


import glob
import os
import sys

#-------------------------------------------
def get_vars(dictNow,lines):
	keys_list = list(dictNow)
	
	varDic = {}

	for line in lines:
		#print(keys_list[0])
		for func in keys_list:
			tam = len(func.strip())
			if line[0:len(func)] == func and line[tam]=="_":
				#print("func:",func)
				#print("line:",line)
				newline = line[tam+1:]
				#print("ltp1:",line[tam])
				#if newline[0]!="_":
				#	break
				#print("nlin:",newline)
				partes = newline.split()
				varNam = partes[0]
				position = varNam.rfind("_")
				#print(position)
				varDic[varNam[0:position]] = len(varNam[0:position])
				#print(varNam[0:position])
				
	return varDic

#-------------------------------------------
def get_proc_info(procedure):

	os.system("grep -in '"+procedure+"' *.f90 > proc.txt")
	ffun = open("proc.txt",'r')
	flines = ffun.readlines()
	ffun.close
	
	ffun = open("proc.txt",'w')
	
	for fline in flines:
		partes = fline.split(":")
		file = partes[0]
		line = partes[1]
		code = partes[2]
		if code[0]=="!":
			continue
		ffun.write(fline.lower())
	
	ffun.close()
	
	ffun = open("proc.txt",'r')
	flines = ffun.readlines()
	ffun.close
	
	aberto = False
	procDict = {}
	for fline in flines:
		partes = fline.split(":")
		file = partes[0]
		line = int(partes[1])
		code = partes[2]
		partes = code.split()
		position=partes.index(procedure.strip())
		if partes[0]!="end":
			procname=partes[position+1].split("(")[0]
		if not aberto:
			inicio = line
			aberto = True
		else:
			linhas = line-inicio
			aberto = False
			procDict[procname] = linhas
			#print(funcname,linhas)
	
	ffun.close()
	return procDict

#-------------------------------------------
def get_file_info():

	sources_files = glob.glob("*.f90")

	razao = {}
	for file_name in sources_files:
		vazio = 0
		comentario = 0
		codigo = 0
		texto = 0
		file = open(file_name,'r')
		lines = file.readlines()
		file.close()
		for line in lines:
			#print(line)
			if len(line.strip())==0:
				vazio = vazio+1
				continue
			primeiro_char = line.strip()[0]
			linhaDeComentario = line.strip()[1:]
			#print(primeiro_char,linhaDeComentario)
			if primeiro_char=="!":
				comentario = comentario+1
				if len(linhaDeComentario)>0:
					texto = texto+1
			else:
				codigo = codigo+1
		if codigo == 0:
			print("Vazio: ",file_name)
		else:
			razao[file_name] = [len(lines),comentario,texto,codigo,texto/codigo]

	return razao

#-------------------------------------------
def get_use_info():

	sources_files = glob.glob("*.f90")

	use = {}
	for file_name in sources_files:
		nuse = 0
		nonly = 0
		file = open(file_name,'r')
		lines = file.readlines()
		file.close()
		for line in lines:
			if len(line.strip())<2:
				continue
			#print(line)
			primeiro_char = line.strip()[0]
			if primeiro_char=="!":
				continue
			#print(line.strip()[0:3].lower())
			if line.strip()[0:3].lower()=="use":
				nuse = nuse+1
				if "only" in line.strip().lower():
					nonly = nonly+1
		use[file_name] = [nuse,nonly]

	return use

#-------------------------------------------
def get_call_info():

	sources_files = glob.glob("*.f90")

	call = {}
	for file_name in sources_files:
		subs = []
		file = open(file_name,'r')
		lines = file.readlines()
		file.close()
		for li in lines:
			line = li.lower()
			if len(line.strip())<2:
				continue
			ls = line.split()
			primeiro_char = ls[0]
			if primeiro_char=="!":
				continue
			try:
				call_pos = ls.index("call")
			except:
				continue
			sub_name = ls[call_pos+1]
			subs.append(sub_name.split("(")[0])

		call[file_name] = subs

	return call


#-------------------------------------------
def get_code_info():

	sources_files = glob.glob("*.f90")

	gotoinfo = {}
	for file_name in sources_files:
		goto = 0
		exit = 0
		cycle = 0
		do = 0
		implicit = 0
		equivalence = 0
		common = 0
		continue_ = 0
		file = open(file_name,'r')
		lines = file.readlines()
		file.close()
		for line in lines:
			if len(line.strip())<2:
				continue
			#print(line)
			primeiro_char = line.strip()[0]
			if primeiro_char=="!":
				continue
			#print(line.strip()[0:3].lower())
			if "goto" in line.strip().lower():
					goto = goto+1
			if "go to" in line.strip().lower():
					goto = goto+1
			if "exit" in line.strip().lower():
					exit = exit+1
			if "cycle" in line.strip().lower():
					cycle = cycle+1		
			if "end do" in line.strip().lower():
					do = do+1	
			if "enddo" in line.strip().lower():
					do = do+1	
			if "implicit none" in line.strip().lower():
					implicit = implicit+1	
			if "equivalence" in line.strip().lower():
					equivalence = equivalence+1	
			if "common" in line.strip().lower():
					common = common+1	
			if "continue" in line.strip().lower():
				continue_ = continue_+1								
		gotoinfo[file_name] = [do,goto,exit,cycle,implicit,equivalence,common,continue_]

	return gotoinfo

def verifica_keywords1(line):
	ls = line.split()
	if len(ls)>0:
		if ls[0].isdigit():
			return True
	if line[0:3]=="do ":
		return True
	elif line[0:5]=="enddo": 
		return True
	elif line[0:6]=="end do":
		return True
	else: 
		return False

def busca_end(li,label,do_data):
	aninhado = 0
	max_aninhamento=0
	for do in do_data:
		if do[0]<=li:
			continue
		if do[1]==label:
			return do[0],max_aninhamento
		if do[1]=="do":
			aninhado = aninhado+1
			max_aninhamento=max(max_aninhamento,aninhado)
	return 0,0

def busca_end_2(li,do_data):
	aninhado = 0
	max_aninhamento=0
	for do in do_data:
		if do[0]<=li:
			continue
		if do[1]=="do" and do[2]=='':
			aninhado = aninhado+1
			max_aninhamento=max(max_aninhamento,aninhado)
		if do[1]=="end" and aninhado==0:
			return do[0],max_aninhamento
		if do[1]=="end" and aninhado>0:
			aninhado = aninhado-1

	return 0,0

def checkDo():
	sources_files = glob.glob("*.f90")
	do_info = []
	for file in sources_files:
		
		fn = open(file,"r")
		lines = fn.readlines()
		fn.close()
	
		fo = open(file+".do","w")
		
		do_data = []
		
	
		line_count = 0
		for line in lines:
			line_count = line_count+1
			line = line.strip().lower()
			if verifica_keywords1(line):
				if line[0]!="!":
					ls = line.split()
					if len(ls)>1:
						if ls[1].isdigit():	
							label = ls[1]
							line = ls[0]
						else:
							label = ''
							line = ls[0]
					do_data.append([line_count,line,label])
					fo.write(line+":"+label+":{0:d}\n".format(line_count))
		fo.close()
	
		#Tratando dos laços com continues numéricos
		for do in do_data:
			label = do[2]
			if len(label)>0:
				linha_inicial = do[0]
				linha_final,max_aninhamento = busca_end(linha_inicial+1,label,do_data)
				do_info.append([file,int(linha_final)-int(linha_inicial),max_aninhamento])

		#Tratando dos laços com do-enddo
		for do in do_data:
			label = do[2]
			if len(label)==0 and do[1]=="do":
				linha_inicial = do[0]
				linha_final,max_aninhamento = busca_end_2(linha_inicial+1,do_data)
				do_info.append([file,int(linha_final)-int(linha_inicial),max_aninhamento])
	
	return do_info

def verifica_keywords2(line):
	ls = line.split()
	if line[0:10]=="subroutine":
		return True
	ls = line.split()
	if len(ls)==0:
		return False
	primeiro_char = ls[0]
	if primeiro_char=="!":
		return False
	try:
		call_pos = ls.index("call")
	except:
		return False
	return True

def checkCalls():
	sources_files = glob.glob("*.f90")
	lines_valid = []
	call_info = {}
	for file in sources_files:
		subname = ''
		
		fn = open(file,"r")
		lines = fn.readlines()
		fn.close()
	
		fo = open(file+".call","w")
		
		
		subs = []
		
		for line in lines:
			line = line.strip().lower()
			if verifica_keywords2(line):
				lines_valid.append(line)

				fo.write(line+"\n")

		fo.close()

		for line in lines_valid:
			if line[0:10] == 'subroutine':
				subname = line.split()[1]
				subname = subname.split("(")[0]
				continue
			ls = line.split()
			try:
				call_pos = ls.index("call")
			except:
				continue
			sub_name = ls[call_pos+1]
			subs.append(sub_name.split("(")[0])
		
		if subname != '':
			call_info[subname] = subs

	return call_info

#print("--Funct info--")
functInfo = get_proc_info(" function ")
#print(len(functInfo),functInfo)

#print("--Sub info--")
subInfo = get_proc_info("subroutine")
#print(len(subInfo),subInfo)

#print("--Mod info--")
modInfo = get_proc_info(" module ")
#print(len(modInfo),modInfo)

fn = open("all.type.txt","r")
lines = fn.readlines()
fn.close()

#print("Functions --------------------------")
funcVars = get_vars(functInfo,lines)
#print(len(funcVars),funcVars)
#print("subroutines --------------------------")
subVars = get_vars(subInfo,lines)
#print(len(subVars),subVars)
#print("Modules --------------------------")
modVars = get_vars(modInfo,lines)
#print(len(modVars),modVars)
#print("Documents --------------------------")
document = get_file_info()
#print(document)
#print("Uses --------------------------")
use = get_use_info()
#print(use)
#print("Code --------------------------")
codeinfo=get_code_info()
#print(codeinfo)
#print(len(functInfo)+len(modInfo)+len(subInfo))
#print("Do loop --------------------------")
do_info = checkDo()
#print(do_info)
#print("Calls --------------------------")
call = checkCalls()
#print(call)

print('================================================================================================')
print('================================================================================================')
print('|                                      RELATÓRIOS                                              |')
print('================================================================================================')
print('================================================================================================')
ttot = 0
for i in functInfo:
	ttot = ttot+functInfo[i]
tm = ttot/len(functInfo)
print('+ tamanho médio (linhas) das funções   : ',tm)

ttot = 0
for i in subInfo:
	ttot = ttot+subInfo[i]
tm = ttot/len(subInfo)
print('+ tamanho médio (linhas) das subrotinas   : ',tm)

ttot = 0
for i in modInfo:
	ttot = ttot+modInfo[i]
tm = ttot/len(modInfo)
print('+ tamanho médio (linhas) dos módulos   : ',tm)

ttot = 0
for i in funcVars:
	ttot = ttot+funcVars[i]
tm = ttot/len(funcVars)
print('+ tamanho médio do nome das variáveis em funções   : ',tm)

ttot = 0
for i in subVars:
	ttot = ttot+subVars[i]
tm = ttot/len(subVars)
print('+ tamanho médio do nome das variáveis em subrotinas: ',tm)

ttot = 0
for i in modVars:
	ttot = ttot+modVars[i]
tm = ttot/len(modVars)
print('+ tamanho médio do nome das variáveis em módulos: ',tm)

ttot = 0
for i in document:
	ttot = ttot+document[i][4]
tm = ttot/len(document)
print('+ razão média de documentação: ',tm)

ttot1 = 0
ttot2 = 0
for i in use:
	ttot1 = ttot1+use[i][0]
	ttot2 = ttot2+use[i][1]
tm = ttot2/ttot1*100
print('+ razão de only em uses: ',tm,'%')

ttot1 = 0
ttot2 = 0
ttot3 = 0
ttot4 = 0
ttot5 = 0
ttot6 = 0
ttot7 = 0
ttot8 = 0
for i in codeinfo:
	ttot1 = ttot1+codeinfo[i][0]
	ttot2 = ttot2+codeinfo[i][1]
	ttot3 = ttot3+codeinfo[i][2]
	ttot4 = ttot4+codeinfo[i][3]
	ttot5 = ttot5+codeinfo[i][4]
	ttot6 = ttot6+codeinfo[i][5]
	ttot7 = ttot7+codeinfo[i][6]
	ttot8 = ttot8+codeinfo[i][7]
tm = ttot2/(ttot1+ttot8)*100
print('+ razão de "goto" por laço: ',tm,'% (',ttot2,')')
tm = ttot3/(ttot1+ttot8)*100
print('+ razão de "exit" por laço: ',tm,'% (',ttot3,')')
tm = ttot4/(ttot1+ttot8)*100
print('+ razão de "cycle" por laço: ',tm,'% (',ttot4,')')
tm = ttot8/ttot1*100
print('+ razão entre "continue" e "enddo": ',tm,'%')
tm = ttot5/(len(funcVars)+len(subVars)+len(modVars))*100
print('+ razão do uso de "implicit": ',tm,'%',', ',ttot5,' em ',len(funcVars)+len(subVars)+len(modVars),' procedures')
tm = ttot6+ttot7
print('+ total de "equivalence" ou "common": ',tm)

ttot1 = 0
ttot2 = 0
count = 0
for i in do_info:
	if i[1]>0:
		count = count+1
		ttot1 = ttot1+i[1]
		ttot2 = ttot2+i[2]
tm = ttot1/count
tm1 = ttot2/count
print('+ profundidade (linhas) média de laços: ',tm)
print('+ aninhamento (linhas) médio de laços: ',tm1)

ttot = 0
for i in call:
	ttot = ttot+len(call[i])
tm = ttot/len(subVars)
print('+ Média de "call" em subrotina: ',tm)

#for i in call.keys():
#	for j in call[i]:
#		print(i,j)
#print(call)

ncall = {}
for i in subInfo.keys():
	ncall[i] = 0
	for j in call.keys():
		for k in call[j]:
			if k==i:
				ncall[i] = ncall[i]+1

ttot = 0			
for i in ncall:
	ttot = ttot+ncall[i]
tm = ttot/len(ncall)
print('+ Média de chamadas por subrotina: ',tm)
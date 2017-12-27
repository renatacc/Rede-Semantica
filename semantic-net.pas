{******************************************************************************************************************
 *  Nome do aplicativo: semantic-net																		       		  *
 *  																											  *
 *  Desenvolvedores: Ana Paula Fernandes Souza - 0022647;														  *
 *                   Renata Caroline Cunha     - 0022429.														  *																								  
 *                                                                                                                *
 *  Intruções de compilação: Deve ser compilado utilizando o Free Pascal(Obs: ao utilizar outro compilador com    *
 *  linguagem pascal, poderá ocorrer erros e não reconhecer alguns comandos.) 									  * 			
 * 										                                                                          *
 *	Ambiente de desenvolvimento: Free Pascal, Notepad++ e Graphviz.                                               *
 *																												  *
 *  Data da última atualização: 30/01/2016  																	  *
 *																												  *
 *  Objetivo do arquivo: Gerar um arquivo.dot para representação de redes semânticas no programa Graphviz.        * 
 *																												  *
 ******************************************************************************************************************
}

program Project3;

uses
SysUtils,Variants,Classes,crt;

type

  Tipo_vetor=record //Lookup Table para armazenar  objetos, Conceitos e Ideia da rede

          ind:string; //Indice da tabela
          Obj: string; //Objetos da tabela
      end;	  	  	  

var
entrada,map,entra,sai,saida:string;
matriz: array of array of integer;
vetor_coi: array of Tipo_vetor;// Vetor para descrição dos nos da rede semantica.
nos,i,J,r,c,tipo,opcao,cont_rel:integer;
vetor_tipo_rel: array of tipo_vetor; // Vetor para  descrição dos tipos de relecionamentos.
valida:boolean;
{******************************************************************************************************************
 * 																								                  *
 * 3.1 - Este procedimento tem como finalidade receber o arquivo de entrada e verificar sua existência.           *	
 * 																								                  * 
 ****************************************************************************************************************** }
procedure Arquivo_Entrada;
var    arq:text;
begin		
 	Assign(arq,entrada); //Associando o arquivo de entrada.
	if  paramcount = 2
	  then begin
               
			  clrscr; 
	          writeln('Arquivo existe!');
	          entrada:=ParamSTr(1);
	          saida:=ParamStr(2);
				Assign(arq,entrada);
				if FileExists(entrada)
				 then 
				 valida:=true
				 
				 else begin
				 
				         writeln('Arquivo de entrada não existe!');
				         exit;
				         valida:=false;
				      end;
			  
	       end
          else  begin
		  
                    clrscr;
					writeln('Arquivo não existe!');
					Exit;
				
				end;
   
end;


{******************************************************************************************************************
 * 																								                  *
 * Criando a matriz em tempo de execução a partir da quantidade de nós recebidos do arquivo.                      *
 * 																								                  * 
 ****************************************************************************************************************** }
procedure Cria_Matriz;
Begin

 Setlength(Matriz,nos);  //  As células da matriz já tem os valores atribuídos zero.
 
	for I := 0 to nos-1 do
	Begin
	
		Setlength(Matriz[I],nos);
		
	End;
end;


{******************************************************************************************************************
 * 																								                  *
 *  Recebe todas as informações utéis do arquivo e coloca em uma variável,vetor ou matriz.                        *
 * 																								                  * 
 ****************************************************************************************************************** }
procedure pega_dados; 
var arq:text;
    texto:string;
	A,B,tam,lin,col,rel:integer;
begin
	cont_rel:=0;
	A:=0;	
	Setlength(vetor_coi,0);
	SetLength(vetor_tipo_rel,0);
	
    Assign(arq,entrada);
    Reset(arq);

       while not (EOF(arq)) do // Enquanto o arquivo não terminar faça...
	     begin
 
		     readln(arq,texto);  // Lê cada linha do arquivo
			 tam:=length(texto); // Recebe o tamanho da linha
			 A:=Pos('#',texto);

			 if A<>0 then //Se existir comentário no arquivo, a linha será desconsiderada.
				Begin
					Delete(texto,1,length(texto)); 
					A:=0;
				End
			else begin

			        A:=Pos('N ',texto); //Recebendo a quantidade de nós da rede semântica.

					If A<>0 then
						Begin

							nos:=StrToInt(Copy(texto,A+2,tam-A)); //Pega o tamanho do texto e subrai com o valor da posição de 'N '.
							A:=0;
							Cria_Matriz; //Chamando o procedimento. 
							
						End;

					A:=Pos('n ',texto);

					If A<>0 then  //Recebendo os nós da rede semantica.
						Begin
						
							Setlength(vetor_coi,length(vetor_coi)+1);
							Delete(texto,A+1,1); //Deleta o espaço após o n.
							B:=pos(' ',texto);
							Vetor_coi[length(vetor_coi)-1].ind:=Copy(texto,A+1,B-(A+1)); //Recebendo o índice do conceito, objeto ou ideia da rede semântica.
							Vetor_coi[length(vetor_coi)-1].obj:=Copy(texto,B+1,tam-(B)); //Recebendo o nome do conceito, objeto ou ideia da rede semântica.
							A:=0;
							
						End;

					A:=Pos('K ',texto); 

					If A<>0 then //Recebendo o total de tipos de relacionamentos da rede semântica.
					   Begin

							tipo:=StrToInt(Copy(texto,A+1,tam-A));
							A:=0;

						end;

					A:=Pos('k ',texto);

					If A<>0 then //Recebendo os tipos de relacionamentos da rede semântica.
						Begin
							SetLength(vetor_tipo_rel,length(Vetor_tipo_rel)+1);
							Delete(texto,A+1,1); //Deleta o espaço após o k.
							B:=pos(' ',texto);
							Vetor_tipo_rel[length(vetor_tipo_rel)-1].ind:=Copy(texto,A+1,B-(A+1)); //Recebendo o índice dos tipos de relacionamentos da rede semântica.
							Vetor_tipo_rel[length(vetor_tipo_rel)-1].obj:=Copy(texto,B+1,tam-(B)); //Recebendo o nome dos tipos de relacionamentos da rede semântica.
							A:=0;
						end;

					A:=Pos('r ',texto);

					If A<>0 then
			      	  Begin
					  
						Delete(texto,A+1,1); //Deleta o espaço após o r.
						B:=Pos(' ',texto);
						lin:=StrToInt(Copy(texto,A+1,B-(A+1))); // A variável lin irá receber o índice correspondente a linha da matriz incidência.
						Delete(texto,B,1);  //Deleta o espaço para procurar o próximo.
						A:=Pos(' ',texto);
						col:=StrToInt(Copy(texto,B,A-B)); // A variável col irá receber o índice correspondente a coluna da matriz incidência.
						rel:=StrToInt(Copy(texto,A+1,(length(texto)-A))); // A variável rel irá o tipo de relacionamento que será inserido na matriz incidência.
						Matriz[lin-1,col-1]:=rel; // Há uma subtração na linha e na coluna, porque a matriz dinâmica é indexada de zero.*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*
						A:=0;
						inc(cont_rel);  // Verificando a quantidade de relacionamentos.

						end;

				end;

		  end;

  Close(arq);

end;


{******************************************************************************************************************
 * 																								                  *
 * 3.5 - Este procedimento procura o nó digitado pelo usuário e mostra o nome do objeto.                          *
 * 																								                  * 
 ****************************************************************************************************************** }
function Map_obj(pesq:integer):string;
Begin
  Map_obj:='';
 	For I:=0 to length(Vetor_coi)-1 do
	Begin

		If StrToInt(Vetor_coi[I].ind)=pesq then 
		Begin
		
			Map_obj:=Vetor_coi[I].obj; // Quando o nó for válido, a função receberá o nome do objeto correspondente e sairá do laço. 
			break;
			
		end;
	end;

end;


{******************************************************************************************************************
 * 																								                  *
 * 3.6 - Este procedimento procura o índice digitado pelo usuário e mostra o tipo de relacionamento.              *
 * 																								                  * 
 ****************************************************************************************************************** }
function Map_rel(pesq:integer):string;
Begin
  Map_rel:=''; 
	For I:=0 to length(Vetor_tipo_rel)-1 do
	Begin
		If StrToInt(Vetor_tipo_rel[I].ind)=pesq then
		Begin
		
			Map_rel:=Vetor_tipo_rel[I].obj; // Quando o índice for válido, a função receberá o tipo de relacionamento correspondente e sairá do laço. 
			break;
			
		end;
	end;

end;


{******************************************************************************************************************
 * 																								                  *
 * 3.7.1 - Esta função retorna a quantidade de nós da rede semântica.								              *
 * 																								                  * 
 ****************************************************************************************************************** }
function qtd_nos:integer;
Begin

	qtd_nos:=nos; //Recebe o número de nós estabelecido no arquivo.

End;


{******************************************************************************************************************
 * 																								                  *
 * 3.7.3 - Esta função retorna a quantidade de arcos da rede semântica.								              *
 * 																								                  * 
 ****************************************************************************************************************** }
function qtd_arcos:integer;
Begin

	qtd_arcos:=cont_rel; //Recebe a quantidade de arcos.

end;


{******************************************************************************************************************
 * 																								                  *
 * 3.7.2 - Esta função retorna a densidade dos arcos da rede semântica.								              *
 * 																								                  * 
 ****************************************************************************************************************** }
function densidade:real;
Begin
		
	 densidade:=(cont_rel/(nos*nos))*100; //Fórmula pré-estabelecida na página 13.
	 
end;


{******************************************************************************************************************
 * 																								                  *
 * 3.7.4 - Esta função retorna a quantidade de relacionamentos da rede semântica.								  *
 * 																								                  * 
 ****************************************************************************************************************** }
function qtd_rel(num:integer):integer;
Begin

  qtd_rel:=0;
  
  For i:= 0 to nos-1 do 
    begin
	
	   For j:= 0 to nos-1 do
	      begin
		  
		     If matriz[i,j]=num then
			   begin
			   
			      qtd_rel:=qtd_rel+1;  //Recebe a quantidade de relacionamentos pela matriz.
			   
			   end;
		  
		  end;
    
	end;

end; 


{******************************************************************************************************************
 * 																								                  *
 * 3.7.8 - Esta função retorna quais são os nascedouros da rede semântica.								          *
 * 																								                  * 
 ****************************************************************************************************************** }
function Procura_Coluna(num:integer):integer;
var r:integer; 
begin

  Procura_Coluna:=0;
  
  For r:= 0 to nos-1 do 
    begin
	
	   If Matriz[r,num]<>0
	     then Procura_Coluna:=Procura_Coluna+1;
	
    end;

end;


{******************************************************************************************************************
 * 																								                  *
 * 3.7.7 - Esta função retorna quais são os sorvedouros da rede semântica.								          *
 * 																								                  * 
 ****************************************************************************************************************** }
function Procura_linha(num:integer):integer;
var r:integer; 
begin
  
  Procura_linha:=0;
  
  For r:= 0 to nos-1 do 
    begin
	
	   If Matriz[num,r]<>0
	     then Procura_linha:=Procura_linha+1;
	
    end;

end;


{******************************************************************************************************************
 * 																								                  *
 * 3.8 - Este procedimento gera o arquivo de saída da rede semântica.								              *
 * 																								                  * 
 ****************************************************************************************************************** }
procedure Arquivo_Saida;
var arq:text;
    p,r,s,t,u:integer;
begin

		 Assign(arq,saida); //Associando o arquivo.
		 rewrite(arq); //Recriando o arquivo.
		 
		   Writeln(arq, 'digraph Rede {'); 
             		   
		   For r:=0 to nos-1 do 
		      begin
															
                  Writeln(arq, Vetor_coi[r].ind, ' [label= "', Map_obj(StrToInt(vetor_coi[r].ind)), '"];'); //Escreve o índice e o nome do objeto no arquivo de saída.       
			
			  end;
			  
		  For p:=0 to nos-1 do 
             begin
			 
			     For r:=0 to nos-1 do 
				    begin
					
					   If Matriz[p,r]<>0 //Procurando na matriz um número diferente de zero, caso existir terá que escrever no arquivo.
					     then begin
						         
								 s:=Matriz[p,r];  //Recebendo o valor que está dentro da matriz.
								 
								   For t:= 0 to tipo-1 do //Tipo=quantidade de tipos de relacionamentos.
								     begin
									 
									    If s=StrToInt(vetor_tipo_rel[t].ind) //Procurando no vetor o índice para reconhecer o relacionamento certo. Concertando um possível erro na entrada de um arquivo estruturado que não esteja em ordem crescente.
										  then begin
												
												  u:=t; //Recebendo o índice 
										          break;
												 
										       end;
									 
									 end;
								 
							        writeln(arq,Vetor_coi[p].ind, ' -> ', Vetor_coi[r].ind, ' [label="', Map_rel(StrTOInt(vetor_tipo_rel[u].ind)), '"];'); //Escreve o a ligação e o tipo de relacionamento. 
						 
						      end;
					
			        end;
			 
			 end;
		  
			Writeln(arq, '}');  			
			Close(arq);
   
end;


{******************************************************************************************************************
 * 																								                  *
 * Verifica no arquivo se existe algum tipo de relacionamento mapeado com o número zero.                          *
 * 																								                  * 
 ****************************************************************************************************************** }
function Verifica_Arquivo:boolean;  
var r:integer;
begin

	Verifica_Arquivo:=true; //Se não entrar no if, então o arquivo está com o padrão correto.
	For r:=0 to length(vetor_tipo_rel)-1 do
		begin
	
			If vetor_tipo_rel[r].ind='0'  //Se a função receber valor falso será considerado que o arquivo tem valor 0 no tipo de relacionamento.
				then begin
	   
						Verifica_Arquivo:=false;
						break;
			   
					end;
	
		end;

end;


{******************************************************************************************************************
 * 																								                  *
 * Ínicio do programa.																	                          *
 * 																								                  * 
 ****************************************************************************************************************** }
Begin

	Clrscr;

	Arquivo_Entrada;
	
if valida then
Begin	
  
	pega_dados;

	If Verifica_Arquivo=false
		then begin
   
				writeln('O arquivo de entrada esta com padrao incorreto');
				readkey;
				exit;
           
			end;

				Writeln('Estatísticas:');
				Writeln('==========');
				
				Writeln('1.Geral');
				writeln;
				Writeln('- Numero de nos : ' ,qtd_nos);
				delay(500);
				Writeln('- Numero de arcos: ',qtd_arcos);
				delay(500);
				Writeln('- Densidade: ',densidade:0:2,'%');
				delay(500);
				Writeln;
				
				Writeln('2. Quantidade de relacionamentos ocorreram :');
				writeln;
								
				For r:=0 to tipo-1 do
				Begin
					 
					j:=qtd_rel(r+1);				
					Writeln('- ',Vetor_tipo_rel[r].obj,': ',j,'/',qtd_arcos);
					delay(500);
					
				end; //end do for
				
				writeln;
				Writeln('3.Saída de nós');
				
				For c:=0 to nos-1 do
				  begin
				  
					entra:='';
					sai:='';
					
					If Procura_Coluna(c)=0 
					  then entra:=  ' (Nascedouro) ';
					  
					If Procura_linha(c)=0
					  then sai:= ' (Sorvedouro) '; 
					  
					delay(500);
				    writeln('- ',vetor_coi[c].obj, ': Entra ', Procura_Coluna(c), entra,' , Sai ', Procura_linha(c), sai); 
				  
				  end;
			
				writeln;
				writeln('Fim');
			
		Arquivo_Saida;
	 
end;
	 
readkey;
End.

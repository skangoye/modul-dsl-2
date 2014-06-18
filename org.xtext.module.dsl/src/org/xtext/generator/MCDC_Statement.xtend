package org.xtext.generator

import java.util.ArrayList
import java.util.List
import java.util.Set
import java.util.TreeSet
import org.xtext.helper.Couple
import static extension org.xtext.generator.MCDC_GeneratorUtils.*
import org.xtext.moduleDsl.ERROR_STATEMENT
import org.xtext.moduleDsl.EXPRESSION
import org.xtext.moduleDsl.AbstractVAR_DECL
import org.xtext.moduleDsl.TmpVAR_DECL
import org.xtext.moduleDsl.boolConstant
import org.xtext.helper.Triplet
import org.xtext.moduleDsl.ASSIGN_STATEMENT
import org.xtext.moduleDsl.IF_STATEMENT
import org.xtext.moduleDsl.STATEMENT

import org.xtext.solver.ProblemChoco

import static org.xtext.solver.ChocoUtils.*
import choco.kernel.model.variables.integer.IntegerVariable

class MCDC_Statement {
	var identifier = -1
	val mcdcOfCond= new MCDC_Generator()
	val listOfBooleanExpression = new ArrayList<EXPRESSION>
	val listOfMcdcValues = new ArrayList<List<String>>
	
	def mcdcErrorStatement(ERROR_STATEMENT statement){
		return null
	}
	
	def mcdcVarStatement(AbstractVAR_DECL statement){
		if(statement.type.type != "bool"){
			return null
		}
		else{//statement is of type 'TmpVar_DECL' and 'bool'
			
			val List<String> varInExpression = new ArrayList<String>
			val booleanExpression = (statement as TmpVAR_DECL).value
			
			varInExpression.add((statement as TmpVAR_DECL).name)
			varInExpression(booleanExpression, varInExpression)
			
			val mcdcValues = mcdcOfCond.mcdcOfBooleanExpression(booleanExpression).reduceList
			identifier = identifier + 1
			listOfBooleanExpression.add(identifier, booleanExpression)
			listOfMcdcValues.add(identifier, mcdcValues)
			
			return new Triplet(varInExpression, mcdcValues, identifier.toString)
		}
	}
	
	def mcdcAssignStatement(ASSIGN_STATEMENT statement){
		val assign = (statement as ASSIGN_STATEMENT)
		val booleanExpression = assign.right
		val variable = assign.left.variable
		
		if(variable.type.type != "bool"){
			return null
		}
		else{
			val List<String> varInExpression = new ArrayList<String>
				varInExpression.add(variable.name)
				varInExpression(booleanExpression, varInExpression)
				
				val mcdcValues = mcdcOfCond.mcdcOfBooleanExpression(booleanExpression).reduceList
				identifier = identifier + 1
				listOfBooleanExpression.add(identifier, booleanExpression)
				listOfMcdcValues.add(identifier, mcdcValues)
				
				return new Triplet(varInExpression, mcdcValues, identifier.toString)
		}
	}
	
	def mcdcIfStatement(IF_STATEMENT statement){
		val ifBooleanExpression = (statement as IF_STATEMENT).ifCond
		val mcdcValues = mcdcOfCond.mcdcOfBooleanExpression(ifBooleanExpression)
		
		identifier = identifier + 1
		listOfBooleanExpression.add(identifier, ifBooleanExpression)
		listOfMcdcValues.add(identifier, mcdcValues.reduceList)
		
		val List<String> varInExpression = new ArrayList<String>
		varInExpression.add("*")
		varInExpression(ifBooleanExpression, varInExpression)
				
		val mcdcTrueValues =  (mcdcValues.filter[ it.second == "T"].toList).reduceList
		val mcdcFalseValues = (mcdcValues.filter[ it.second == "F"].toList).reduceList
		
		val listT = new ArrayList< Triplet < List<String>, List<String>, String > >
	 	val listF = new ArrayList< Triplet< List<String>, List<String>, String > >
	 	
		listT.add(new Triplet(varInExpression, mcdcTrueValues, identifier.toString)) 
		listF.add(new Triplet(varInExpression, mcdcFalseValues, identifier.toString)) 
		
		val result = new ArrayList<List<Triplet< List<String>, List<String>, String >>>
		
		mcdcOfConditional(statement.ifst, listT, result)
		mcdcOfConditional(statement.elst, listF, result)
		
		return result
		//result.shrinkList
		/*val result2 = result.copyListOfList
		result2.assignVariableIdentifier
		
		for(r: result2){
			System.out.println("{")
			
			for(rr: r){
				System.out.print(rr.first.toString + " => ")
				System.out.print(rr.second.toString + " => " )
				System.out.println(rr.third)
			}
			
			System.out.println("}")
			System.out.println
		}
		//concat mcdc values
		
		System.out.println
		System.out.println("####### TEST SUITES #######")
		val concatResult = concatMcdcValues(result2)	
			for(cr: concatResult){
				System.out.print(cr.first.toString + " => ")
				System.out.print(cr.second.toString + " => " )
				System.out.println(cr.third)
				System.out.println
			}
		System.out.println
		System.out.println("####### COVERAGE RESULT #######")
		val splitResult = splitConcatenatedValues(concatResult)
			for(sr: splitResult){
				System.out.print(sr.first.toString + " => ")
				System.out.print(sr.second.toString + " => " )
				System.out.println(sr.third)
				System.out.println
			}
		val notCoveredValues = notCoveredValues(splitResult)
		System.out.println
		System.out.println("####### NOT COVERED ####### ")
		for(nc: notCoveredValues){
				System.out.print(nc.first.toString + " => ")
				System.out.print(nc.second.toString + " => " )
				System.out.println(nc.third)
				System.out.println
		}
		
		val listOfEquations = buildEquations(notCoveredValues, result2)
		System.out.println
		System.out.println ("####### EQUATIONS ####### ")
		
		for(eq: listOfEquations){
			System.out.println("{")
			
			for(rr: eq){
				System.out.print(rr.first.toString + " => ")
				System.out.print(rr.second.toString + " => " )
				System.out.println(rr.third)
			}
			
			System.out.println("}")
			System.out.println
		}
		
		System.out.println("####### Solving... #######")
		for(equations: listOfEquations){
			translateAndSolveEquationsWithChoco(equations)
		}*/
		
		}//mcdcIfStatement
		
		
	def private void mcdcOfConditional(List<STATEMENT> statements, ArrayList<Triplet<List<String>,List<String>,String>> triplets,
		List<List<Triplet <List<String>, List<String>, String>>> result) {
		
		//Copy all the elements of the list "triplets" in listT and ListF
		val list = triplets.copyListOfTriplet
	 	
	 	var count = 0	
		for(st: statements){
			if(st instanceof ASSIGN_STATEMENT){
				val triplet = mcdcAssignStatement(st as ASSIGN_STATEMENT)
				if(triplet != null){
					list.add(triplet)
				}
			}
			else{
				if(st instanceof AbstractVAR_DECL){
					val triplet = mcdcVarStatement(st as AbstractVAR_DECL)
					if(triplet != null){
						list.add(triplet)
					}
				}
				else{
					if(st instanceof IF_STATEMENT){
						
						count = count + 1
						
						val ifBooleanExpression = (st as IF_STATEMENT).ifCond
						val mcdcValues = mcdcOfCond.mcdcOfBooleanExpression(ifBooleanExpression)
		
						identifier = identifier + 1
						listOfBooleanExpression.add(identifier, ifBooleanExpression)
						listOfMcdcValues.add(identifier, mcdcValues.reduceList)
						
						val List<String> varInExpression = new ArrayList<String>
						varInExpression.add("*")
						varInExpression(ifBooleanExpression, varInExpression)
						
						val mcdcTrueValues = (mcdcValues.filter[ it.second == "T"].toList).reduceList
						val mcdcFalseValues = (mcdcValues.filter[ it.second == "F"].toList).reduceList
		
						val listT = new ArrayList< Triplet < List<String>, List<String>, String > >
						listT.addAll(list)
	 					val listF = new ArrayList< Triplet< List<String>, List<String>, String > >
	 					listF.addAll(list)
	 					
	 					listT.add(new Triplet(varInExpression, mcdcTrueValues, identifier.toString))
	 					listF.add(new Triplet(varInExpression, mcdcFalseValues, identifier.toString)) 
	 					
	 					mcdcOfConditional((st as IF_STATEMENT).ifst, listT, result)
						mcdcOfConditional((st as IF_STATEMENT).elst, listF, result)
					}
				}
			}
		}//for
		
		if(count == 0){
			result.add(list)
		}
	}//mcdcOfConditional
	
	def concatMcdcValues(List<List<Triplet<List<String>,List<String>,String>>> listOfList) {
		
		val resultOfConcat = new ArrayList<Triplet<List<String>, List<String>, String>>
		
		for(currentList: listOfList){
			val size = currentList.size
			if(size == 0){
				throw new Exception("List cannot be empty")
			}
			else{
				if(size == 1){
					resultOfConcat.add(currentList.get(0))
				}
				else{//size > 1
					//copy in a new list the currentList's elements
					var  copyList = currentList.copyListOfTriplet.reverse
					if(copyList.noVarInCommon){
						var triplet1 = copyList.get(1)
						var triplet2 = copyList.get(0)
						while(copyList.size != 1){
							//set the first element with the concatenated value
							copyList.set(0, concatWithoutConstraints(triplet1,triplet2))
							copyList.remove(1)
							
							if(copyList.size != 1){
								triplet1 = copyList.get(1) //assign the second element of copyList to triplet1
								triplet2 = copyList.get(0) //assign the second element of copyList to triplet1
							}
						}
					}
					else{//some variables are propagated along the path
						var triplet1 = copyList.get(1)
						var triplet2 = copyList.get(0)
						while(copyList.size != 1){
							//set the first element with the concatenated value
							copyList.set(0, concatWithConstraints(triplet1,triplet2))
							copyList.remove(1)
							
							if(copyList.size != 1){
								triplet1 = copyList.get(1) //assign the second element of copyList to triplet1
								triplet2 = copyList.get(0) //assign the second element of copyList to triplet1
							}
						}
					}
					resultOfConcat.add(copyList.get(0))
				}//else
			}
			
		}//for
		return resultOfConcat
	}//concatMcdcValues
	
	
	def private concatWithoutConstraints(Triplet<List<String>,List<String>,String> t1,Triplet<List<String>,List<String>,String> t2) {
		
		val List<String> concatValues = new ArrayList<String> //will hold the concatenation result of the 'list1' and 'list2'
		val List<String> concatVariables = new ArrayList<String> //will hold the concatenation result of the list of Variables in t1 and t2 
		val concatIdents = t1.third + "#" + t2.third //concatenation of the idents in t1 and t2
		
		concatVariables.addAll(t1.first)
		concatVariables.addAll("#")
		concatVariables.addAll(t2.first)
		
		val list1 = t1.second //list of MCDC values in t1
		val list2 = t2.second //list of MCDC values in t2
		
		val size1 = list1.size //size of list1
		val size2 = list2.size //size of list2
		
		if (size1 == 0 || size2 == 0){
			throw new Exception("Illegal arguments")
		}
		
		val minSize = Math.min(size1, size2)
		val maxSize = Math.max(size1, size2)
		
		//concatenate the first 'minSize' elements of the two lists
		var i =0
		do{
			val v1 = list1.get(i)
			val v2 = list2.get(i)
		
			concatValues.add( v1 + "#" + v2)
			
		} while ((i=i+1) < minSize)
		
		//list2 is bigger than list1
		if (size1 < size2){
			var j = minSize
			do{
				val index= (Math.random()*minSize).intValue
				
				val v1 = list1.get(index)
				val v2 = list2.get(j)
				
				concatValues.add( v1 + "#" + v2)
				
			} while ((j=j+1) < maxSize)
		}
		else{
			//list1 is bigger than list2
			if (size1 > size2){
				var k = minSize
				do{
					val index= (Math.random()*minSize).intValue
					
					val v1 = list1.get(k)
					val v2 = list2.get(index)
					
					concatValues.add( v1 + "#" + v2)
					
				} while ((k=k+1) < maxSize)
			}
		}//else
		
		return new Triplet (concatVariables, concatValues, concatIdents)
	}//concatWithoutConstraints
	
	def private concatWithConstraints(Triplet<List<String>,List<String>,String> t1,Triplet<List<String>,List<String>,String> t2){
		
		val List<String> concatValues = new ArrayList<String> //will hold the concatenation result of the 'listOfvariables1' and 'listOfvariables2'
		
		val listOfvariables1 = t1.first 
		val listOfvariables2 = t2.first
		
		val List<String> concatVariables = new ArrayList<String> //will hold the concatenation result of the list of Variables in t1 and t2 
		concatVariables.addAll(listOfvariables1)
		concatVariables.add("#")
		concatVariables.addAll(listOfvariables2)
		
		val listOfValues1 = t1.second
		val listOfValues2 = t2.second
		
		val concatIdents = t1.third + "#" + t2.third //concatenation of the idents in t1 and t2
		
		val indexes = indexOfCommonVars(listOfvariables1, listOfvariables2)
		
		/*System.out.println("common indexes of: " + listOfvariables1.toString + " and " + listOfvariables2.toString)
		for(i:indexes){
			System.out.println("(" + i.first + "," + i.second + ")")
		}*/
		
		for(v1:listOfValues1){
			for(v2:listOfValues2){
				if (meetConstraints(v1, v2, indexes)){
					concatValues.add(v1 + "#" + v2)
				}
			}//for
		}//for
		
		return new Triplet (concatVariables, concatValues, concatIdents)
	}//concatWithConstraints
	
	def private boolean  meetConstraints(String str1, String str2, List<Couple<Integer,Integer>> indexes) {
		val str1ToArray = str1.toCharArray
		val str2ToArray = str2.toCharArray
		
		for(ic: indexes){
			if (str1ToArray.get(ic.first.intValue).toString != str2ToArray.get(ic.second.intValue).toString){
				return false
			}
		}
		return true
	}//meetConstraints
	
	def splitConcatenatedValues(List<Triplet<List<String>, List<String>, String>> concatValues){
		
		val splitConcatenatedResults = new ArrayList<Triplet<List<String>, Set<String>, String>>
		
		for(triplet: concatValues){
			
			val variables = triplet.first
			val values = triplet.second
			val identSequence = triplet.third
			
			//indexes delimited by the separator '#'
			//The indexes of variables can be used to split the values
			val indexOfvariables = variables.indexesBeforeSeparator
			val indexOfIdents = (identSequence.toStringArray).indexesBeforeSeparator
			
			var i = 0
			val size = indexOfvariables.size
			do{
				val varLeftIndex = indexOfvariables.get(i).first
				val varRigthIndex = indexOfvariables.get(i).second
				
				val identLeftIndex = indexOfIdents.get(i).first
				val identRightIndex = indexOfIdents.get(i).second
				
				//sub-list of variables
				val varSubList = variables.subList(varLeftIndex, varRigthIndex + 1)
				val ident = identSequence.substring(identLeftIndex, identRightIndex + 1)
				val Set<String> splitValues = new TreeSet<String>
				values.forEach[v | splitValues.add(v.substring(varLeftIndex, varRigthIndex+1))]
				
				splitConcatenatedResults.add(new Triplet(varSubList, splitValues, ident))
				
			}while ( (i=i+1) < size)
		
		}//for
		
		//map triplets having same idents
	 	var j = 0
		do{
			val tmp = splitConcatenatedResults.get(j)
			
			val dup = splitConcatenatedResults.findFirst[ (it != tmp) && (it.third == tmp.third)]
			
			if (dup != null){
				tmp.second.addAll(dup.second)
				splitConcatenatedResults.remove(dup)
				j = j - 1
			}
			
		}while ( (j=j+1) < splitConcatenatedResults.size)
		
		return splitConcatenatedResults
	}//splitConcatenatedValues
	
	def notCoveredValues(List<Triplet<List<String>, Set<String>, String>> splitList){
		val notCoveredList = new ArrayList<Triplet<List<String>, List<String>, String>>
		
		for(triplet:splitList){
			val identifier = triplet.third.parseInt
			val mcdcValues = listOfMcdcValues.get(identifier)
			val actualValues = triplet.second.toList
			
			//seek values that are in mcdcValues and not in values
			val valuesDiff = listDiff(mcdcValues, actualValues)
			if (valuesDiff.size != 0){
				notCoveredList.add(new Triplet(triplet.first, valuesDiff, triplet.third))
			}	
		}//for
		return notCoveredList
	}//notCoveredList
	
	def buildEquations( List<Triplet<List<String>,List<String>,String>> notCoveredList, 
					  List<List<Triplet<List<String>,List<String>,String>>> listOfList){
		
		val listOfEquations =  new ArrayList<List<Triplet<List<String>,List<String>,String>>>
		
		for(triplet: notCoveredList){
			
			val listOfVariable = triplet.first
			val listOfUncoveredValues = triplet.second
			val ident = triplet.third
			for(uncoveredVal: listOfUncoveredValues){
				listOfList.forEach[ list |  val match = list.findFirst[ (it.third == ident) && (it.first.equals(listOfVariable)) && (it.second.contains(uncoveredVal))]//find first
					if (match != null){
						val targetIndex = list.indexOf(match)
						val matchList = list.copyListOfTriplet
						//set the second param of the target triplet with the uncovered value
						matchList.get(targetIndex).setSecond(uncoveredVal.toStringArray)
						
						var cpt = 0
						val size = matchList.size
						
						val targetTriplet = matchList.get(targetIndex)
						val targetListOfVariables = targetTriplet.first
						do{
							if(cpt != targetIndex){
								
								val currentTriplet = matchList.get(cpt)
								val currentListOfVariables = currentTriplet.first
								
								if(currentTriplet.first.get(0) == "*"){
									//retrieve the outcome value of the condition
									val outcome = currentTriplet.second.get(0).charAt(0)
									//set all the values of the current
									currentTriplet.setSecond( (outcome + (currentListOfVariables.size-1).unknownStringVector).toStringArray)
								}
								else{
									//set all the values of the current
									currentTriplet.setSecond(currentListOfVariables.size.unknownStringVector.toStringArray)
								}
								
								if(currentListOfVariables.intersectionOfLists(targetListOfVariables).size > 0){
									//the two lists have some variables in common
									//retrieve theirs indexes
									val indexesOfcommonVars = indexOfCommonVars(targetListOfVariables, currentListOfVariables) 
									
									for(i: indexesOfcommonVars){
										currentTriplet.second.set(i.second, targetTriplet.second.get(i.first))
									}//for i
								
								}//if currentListOfVariables
							
							}
						} while( (cpt=cpt+1) < size )
					
					listOfEquations.add(matchList)
					
					}//if match
				]//for each
			}//for
		}
	return listOfEquations
	
	}//buildEquations
	
	/**
	 * 
	 */
	def translateAndSolveEquationsWithChoco(List<Triplet<List<String>,List<String>,String>> listOfEquations){
		
		val chocoModel = new ProblemChoco() //choco model
		val integerVarOveralList = new ArrayList< List<IntegerVariable>>
		var starIdent= 1 //
		
		for(equations: listOfEquations){
			
			val integerVarList = new ArrayList<IntegerVariable> //array of listOfEquations' "IntegerVariables"
			
			val variables = equations.first //variables in the triplet
			val values = equations.second //corresponding values of the variables 
			val ident =  equations.third //boolean expression identifier 
			//create variables with choco
			var cpt = 0
			val size = variables.size //variable list size
			do{
				
				var currentVar = variables.get(cpt) //variable to be declared as choco integer variable
				val correpondantValue = values.get(cpt) //corresponding value of the current variable 
	
				if((cpt == 0) && (currentVar == "*")){ //assignment variable
					currentVar = currentVar + "@" + starIdent
					variables.set(0, currentVar) //replace the star '*' with another star with identifier
					starIdent = starIdent + 1 
				
					if(correpondantValue == "*"){
						throw new Exception("Incorrect value")
					}
				}
				
				if(correpondantValue == "*"){
					//define a boolean variable
					integerVarList.add(chocoModel.makeIntVar(currentVar, 0, 1 ) as IntegerVariable)
				}
				else{
					if(correpondantValue == "F"){
						//define a boolean variable with low bound == upper bound == 0
						integerVarList.add(chocoModel.makeIntVar(currentVar, 0, 0 ) as IntegerVariable)
					}
					else{
						if(correpondantValue == "T"){
							//define a boolean variable with low bound == upper bound == 1
							integerVarList.add(chocoModel.makeIntVar(currentVar, 1, 1 ) as IntegerVariable)
						}
						else{
							throw new Exception("unknown value")
						}
					}
				}
	
	
			} while( (cpt=cpt+1) < size )
		
			//gather all choco integer variables in a list
			integerVarOveralList.add(integerVarList)
			
			//create expressions with choco
			val condExpression = listOfBooleanExpression.get(ident.parseInt)
			val chocoExpression = chocoIntegerExpression(condExpression, chocoModel, integerVarList)
			
			val equationResult = values.get(0) //the first element of the values' list is the result of the boolean expression
			val chocoResultVariable = variables.get(0).getChocoIntegerVar(integerVarList)
			
			//create constraints with choco
		 	if(equationResult == "*" || equationResult == "T"){
				
				if (size == 1){
					val constraint = chocoModel.eq(chocoExpression , 1) //
					chocoModel.addConstraint(constraint)//Add constraints 2
				}
				else{
					//The constraints must be >= chocoExpression and <= 1*(Nb of variables involved in expression except the first one) 
					val constraint1 = chocoModel.geq(chocoExpression , chocoResultVariable)
					val constraint2 = chocoModel.leq(chocoExpression , size-1) //
					chocoModel.addConstraint(constraint1)//Add constraint 1
					chocoModel.addConstraint(constraint2) ////Add constraints 2
				}
			
			}//if
			else{
				if(equationResult == "F"){
					val constraint = chocoModel.eq(chocoExpression , chocoResultVariable)
						//Add constraints
						chocoModel.addConstraint(constraint)
				}
				else{
					throw new Exception("unknown value")	
				}
			  }//else
			
		}//for equations
	
		val solve = chocoModel.solve
		
		if(solve){
			for(list: integerVarOveralList){
				for(intVar: list){
					System.out.println( intVar.getName() + ": "+ chocoModel.getIntValue(intVar));
				}
				System.out.println
			}
			System.out.println("######################")
			System.out.println
		}
		else{
			System.out.println("Infeasible")
		}
		
	}//translateAndSolveEquationsWithChoco
	
	def private Object getChocoIntegerVar(String str, List<IntegerVariable> list){
	 	for(e: list){
	 		if(e.name == str){
	 			return e
	 		}
	 	}
	 	throw new Exception("Error choco")
	 }
	 
}//class
package org.xtext.generator

import choco.kernel.model.variables.integer.IntegerVariable
import java.util.ArrayList
import java.util.List
import java.util.Set
import java.util.TreeSet
import org.xtext.helper.Couple
import org.xtext.helper.Triplet
import org.xtext.moduleDsl.ASSIGN_STATEMENT
import org.xtext.moduleDsl.AbstractVAR_DECL
import org.xtext.moduleDsl.ERROR_STATEMENT
import org.xtext.moduleDsl.EXPRESSION
import org.xtext.moduleDsl.IF_STATEMENT
import org.xtext.moduleDsl.STATEMENT
import org.xtext.moduleDsl.TmpVAR_DECL
import org.xtext.solver.ProblemChoco

import static org.xtext.solver.ChocoUtils.*

import static extension org.xtext.generator.MCDC_GeneratorUtils.*

class MCDC_Statement {
	var identifier = -1
	val mcdcOfCond= new MCDC_Generator()
	val listOfBooleanExpression = new ArrayList<EXPRESSION>
	val listOfMcdcValues = new ArrayList<List<String>>
	
	def mcdcErrorStatement(ERROR_STATEMENT statement){
		return null
	}
	
	def mcdcVarStatement(AbstractVAR_DECL statement){
		
		val expression = (statement as TmpVAR_DECL).value
			
		if(statement.type.type != "bool"){
			//val variableValue = stringReprOfExpression(expression)
			//val List<String> stringRepOfVarVal = new ArrayList<String>
			//stringRepOfVarVal.add(variableValue)
			
			//listOfMcdcValues.add(identifier, stringRepOfVarVal)
			
			return null //new Triplet(varInExpression, stringRepOfVarVal, subIdentifier)
		}
		else{//statement is of type 'TmpVar_DECL' and 'bool'
		
			identifier = identifier + 1
			listOfBooleanExpression.add(identifier, expression)
			val List<String> subIdentifier = new ArrayList<String>
			subIdentifier.add(identifier + "X")
			
			val List<String> varInExpression = new ArrayList<String>			
			varInExpression.add((statement as TmpVAR_DECL).name)
			varInExpression(expression, varInExpression)
			
			val mcdcValues = mcdcOfCond.mcdcOfBooleanExpression(expression).reduceList
			
			
			listOfMcdcValues.add(identifier, mcdcValues)
			
			return new Triplet(varInExpression, mcdcValues, subIdentifier)
		}
	}
	
	def mcdcAssignStatement(ASSIGN_STATEMENT statement){
		val assign = (statement as ASSIGN_STATEMENT)
		val booleanExpression = assign.right
		val variable = assign.left.variable
		
		if(variable.type.type != "bool"){
			
			//val variableValue = stringReprOfExpression(booleanExpression)
			//val List<String> stringRepOfVarVal = new ArrayList<String>
			//stringRepOfVarVal.add(variableValue)
			
			//listOfMcdcValues.add(identifier, stringRepOfVarVal)
			
			return null//new Triplet(varInExpression, stringRepOfVarVal, subIdentifier)
		}
		else{
			identifier = identifier + 1
			listOfBooleanExpression.add(identifier, booleanExpression)
			
			val List<String> varInExpression = new ArrayList<String>
			varInExpression.add(variable.name)
			
			val List<String> subIdentifier = new ArrayList<String>
			subIdentifier.add(identifier + "X")
			varInExpression(booleanExpression, varInExpression)
			
			val mcdcValues = mcdcOfCond.mcdcOfBooleanExpression(booleanExpression).reduceList
			
			listOfMcdcValues.add(identifier, mcdcValues)
			
			return new Triplet(varInExpression, mcdcValues, subIdentifier)
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
		
		val List<String> subIdentifierT = new ArrayList<String>
		subIdentifierT.add(identifier + "T")
		val List<String> subIdentifierF = new ArrayList<String>
		subIdentifierF.add(identifier + "F")

		
		val listT = new ArrayList< Triplet < List<String>, List<String>, List<String> > >
	 	val listF = new ArrayList< Triplet< List<String>, List<String>, List<String> > >
		listT.add(new Triplet(varInExpression, mcdcTrueValues, subIdentifierT)) 
		listF.add(new Triplet(varInExpression, mcdcFalseValues, subIdentifierF)) 
		
		val result = new ArrayList<List<Triplet< List<String>, List<String>, List<String> >>>
		
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
		
		
	def private void mcdcOfConditional(List<STATEMENT> statements, ArrayList<Triplet<List<String>,List<String>, List<String> >> triplets,
		List<List<Triplet <List<String>, List<String>, List<String> >>> result) {
		
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
						
						val List<String> subIdentifierT = new ArrayList<String>
						subIdentifierT.add(identifier + "T")
						val List<String> subIdentifierF = new ArrayList<String>
						subIdentifierF.add(identifier + "F")

						
						val listT = new ArrayList< Triplet < List<String>, List<String>, List<String> > >
						listT.addAll(list)
	 					val listF = new ArrayList< Triplet< List<String>, List<String>, List<String> > >
	 					listF.addAll(list)
	 					listT.add(new Triplet(varInExpression, mcdcTrueValues, subIdentifierT))
	 					listF.add(new Triplet(varInExpression, mcdcFalseValues, subIdentifierF)) 
	 					
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
	
	def concatMcdcValues(List<List<Triplet< List<String>, List<String>, List<String> >>> listOfList) {
		
		val resultOfConcat = new ArrayList<Triplet<List<String>, List<String>, List<String> >>
		
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
	
	def concatMcdcValues2(List<List<Triplet< List<String>, List<String>, List<String> >>> listOfList) {
		
		val resultOfConcat = new ArrayList<Triplet<List<String>, List<String>, List<String> >>
		
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
		
					var triplet1 = copyList.get(1)
					var triplet2 = copyList.get(0)
					while(copyList.size != 1){
						
						if( (triplet1.first.intersectionOfLists(triplet2.first)).size > 0 ) {
							//set the first element with the concatenated value
							copyList.set(0, concatWithConstraints(triplet1,triplet2))
						}
						else{
							//set the first element with the concatenated value
							copyList.set(0, concatWithoutConstraints(triplet1,triplet2))	
						}
						
						copyList.remove(1)
						
						if(copyList.size != 1){
							triplet1 = copyList.get(1) //assign the second element of copyList to triplet1
							triplet2 = copyList.get(0) //assign the second element of copyList to triplet1
						}
					}//while
					
					resultOfConcat.add(copyList.get(0))
				}//else
			}
			
		}//for
		return resultOfConcat
	}//concatMcdcValues
	
	def private concatWithoutConstraints(Triplet<List<String>,List<String>, List<String> > t1,Triplet<List<String>,List<String>, List<String> > t2) {
		
		val List<String> concatValues = new ArrayList<String> //will hold the concatenation result of the 'list1' and 'list2'
		val List<String> concatVariables = new ArrayList<String> //will hold the concatenation result of the list of Variables in t1 and t2 
		val List<String> concatIdents = new ArrayList<String> //will hold the concatenation of the t1 and t2 identifiers
		
		concatVariables.addAll(t1.first)
		concatVariables.add("#")
		concatVariables.addAll(t2.first)
		
		concatIdents.addAll(t1.third)
		concatIdents.add("#")
		concatIdents.addAll(t2.third)
		
		val list1 = t1.second //list of MCDC values in t1
		val list2 = t2.second //list of MCDC values in t2
		
		val size1 = list1.size //size of list1
		val size2 = list2.size //size of list2
		
		if (size1 == 0 || size2 == 0){
			return new Triplet (concatVariables, concatValues, concatIdents) //throw new Exception("Illegal arguments")
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
	
	def private concatWithConstraints(Triplet<List<String>,List<String>, List<String>> t1,Triplet<List<String>, List<String>, List<String>> t2){
		
		val List<String> concatValues = new ArrayList<String> //will hold the concatenation result of the 'listOfvariables1' and 'listOfvariables2'
		
		val listOfvariables1 = t1.first 
		val listOfvariables2 = t2.first
		
		val List<String> concatVariables = new ArrayList<String> //will hold the concatenation result of the list of Variables in t1 and t2 
		concatVariables.addAll(listOfvariables1)
		concatVariables.add("#")
		concatVariables.addAll(listOfvariables2)
		
		val List<String> concatIdents = new ArrayList<String>
		concatIdents.addAll(t1.third)
		concatIdents.add("#")
		concatIdents.addAll(t2.third)
		
		/*System.out.println("common indexes of: " + listOfvariables1.toString + " and " + listOfvariables2.toString)
		for(i:indexes){
			System.out.println("(" + i.first + "," + i.second + ")")
		}*/
		
		val indexes = indexOfCommonVars(listOfvariables1, listOfvariables2)
		
		val listOfValues1 = t1.second
		val listOfValues2 = t2.second
	
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
	
	def splitConcatenatedValues(List<Triplet<List<String>, List<String>, List<String> >> concatValues){
		
		val splitConcatenatedResults = new ArrayList<Triplet<List<String>, Set<String>, List<String> >>
		
		for(triplet: concatValues){
			
			val variables = triplet.first
			val values = triplet.second
			val identSequence = triplet.third
			
			//indexes delimited by the separator '#'
			//The indexes of variables can be used to split the values
			val indexOfvariables = variables.indexesBeforeSeparator
			val indexOfIdents = identSequence.indexesBeforeSeparator
			
			var i = 0
			val size = indexOfvariables.size
			do{
				val varLeftIndex = indexOfvariables.get(i).first
				val varRigthIndex = indexOfvariables.get(i).second
				
				val identLeftIndex = indexOfIdents.get(i).first
				val identRightIndex = indexOfIdents.get(i).second
				
				//sub-lists of variables
				val varSubList = variables.subList(varLeftIndex, varRigthIndex + 1)
				val ident = identSequence.subList(identLeftIndex, identRightIndex + 1)
				val Set<String> splitValues = new TreeSet<String>
				values.forEach[v | splitValues.add(v.substring(varLeftIndex, varRigthIndex + 1))]
				
				splitConcatenatedResults.add(new Triplet(varSubList, splitValues, ident))
				
			}while ( (i=i+1) < size )
		
		}//for
		
		//map triplets having same idents
	 	var j = 0
		do{
			val tmp = splitConcatenatedResults.get(j)
			val subIdentifier = tmp.third
			val dup = splitConcatenatedResults.findFirst[(it != tmp) && (it.third.equals(subIdentifier))]
			
			if (dup != null){
				tmp.second.addAll(dup.second)
				splitConcatenatedResults.remove(dup)
				j = j - 1
			}
			
			//filter 'values that are not part of the mcdc values'
			val newValues = tmp.second.keepOnlyMcdcValues(subIdentifier.extractIdentifier.parseInt)
			tmp.setSecond(newValues)
		
		}while ( (j=j+1) < splitConcatenatedResults.size )
		
		return splitConcatenatedResults
	}//splitConcatenatedValues
	
	def notCoveredValues(List<Triplet<List<String>, Set<String>, List<String> >> splitList){
		val notCoveredList = new ArrayList<Triplet<List<String>, List<String>, List<String> >>
		
		for(triplet:splitList){
			
			val subIdentifier = triplet.third
			val identNature = subIdentifier.get(0).getLastChar //either 'T' or 'F' or 'X'
			
			val intIdent = subIdentifier.extractIdentifier.parseInt
			val actualValues = triplet.second.toList
			
			val mcdcValues = new ArrayList<String>
			
			if( identNature == "F" || identNature == "T" ){
				 mcdcValues.addAll(listOfMcdcValues.get(intIdent).filter[ it.charAt(0).toString ==  identNature])
			}
			else{
				if(identNature == "X"){
					 mcdcValues.addAll(listOfMcdcValues.get(intIdent))
				}
				else{
					throw new Exception("Identifier error")
				}
			}
			
			//seek values that are in mcdcValues and not in values
			val valuesDiff = listDiff(mcdcValues, actualValues)
			if (valuesDiff.size != 0){
				notCoveredList.add(new Triplet(triplet.first, valuesDiff, triplet.third))
			}	
		}//for
		return notCoveredList
	}//notCoveredList
	
	def buildEquations( List<Triplet< List<String>, List<String> , List<String> >> notCoveredList, 
					  List<List<Triplet< List<String>, List<String>, List<String> >>> listOfList){
		
		val listOfEquations =  new ArrayList<List<Triplet<List<String>,List<String>, List<String>>>>
		
		for(triplet: notCoveredList){
			
			val listOfVariable = triplet.first
			val listOfUncoveredValues = triplet.second
			val subIdentifier = triplet.third
			
			for(uncoveredVal: listOfUncoveredValues){
				listOfList.forEach[ list |  val match = list.findFirst[ (it.third.equals(subIdentifier)) && (it.first.equals(listOfVariable)) && (it.second.contains(uncoveredVal))]//find first
					if (match != null){
						val targetIndex = list.indexOf(match)
						val matchList = list.copyListOfTriplet
						
						//set the second param of the target triplet with the uncovered value
						matchList.get(targetIndex).setSecond(uncoveredVal.toStringArray)
						
						var cpt = 0
						val size = matchList.size
						
						val targetTriplet = matchList.get(targetIndex)
						val targetListOfVariables = targetTriplet.first
						val listOfIndexes = new ArrayList<String> //records the indexes of triplets whose have one variable in the variable list	  
						
						do{
							
							val currentTriplet = matchList.get(cpt)
							
							if((cpt != targetIndex) && (currentTriplet.first.size > 1)){// the current triplet is not the target triplet
							//nor a triplet whose the variables values are imposed
								
								val currentListOfVariables = currentTriplet.first
								
								if(currentTriplet.first.get(0) == "*"){
									//retrieve the outcome value of the condition
									val outcome = currentTriplet.second.get(0).charAt(0)
									//set all the values of the current
									currentTriplet.setSecond((outcome + (currentListOfVariables.size-1).unknownStringVector).toStringArray)
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
							else{
								if(currentTriplet.first.size == 1){
									//the cuurrent triplet's list of variable holds an imposed value
									// => Store the index of the triplet
									listOfIndexes.add(cpt.toString)
								}
							}
						
						} while( (cpt=cpt+1) < size )
						
						//new loop to propagate imposed variables' values ()
						var addToList = true
						
						for(i: listOfIndexes){
						 
						  val myTriplet = matchList.get(i.parseInt)
						  val myTripletVarList = myTriplet.first
					
						  for(t: matchList){
						  	if(t!=myTriplet){
						  		val currentTripletVarList = t.first
						  		if( currentTripletVarList.intersectionOfLists(myTripletVarList).size > 0){
						  			val indexesOfcommonVars = indexOfCommonVars(currentTripletVarList, myTripletVarList)
						  			
						  			for(indexesCouple: indexesOfcommonVars){
										val myTripletValuesList = myTriplet.second
										val currentTripletValuesList = t.second
										if(currentTripletValuesList.get(indexesCouple.first) =="*"){
											t.second.set(indexesCouple.first, myTripletValuesList.get(indexesCouple.second))
										}
										else{
											if(currentTripletValuesList.get(indexesCouple.first) != myTripletValuesList.get(indexesCouple.second)){
												//equations with no solution
												addToList = false
											}
										}									
									
									}//for indexesCouple
									
						  		}
						  	}
						  }//for
						}				
					
					if(addToList) {
						listOfEquations.add(matchList)
					}
					
					}//if match
				]//for each
			}//for
		}
	return listOfEquations
	
	}//buildEquations
	
	/**
	 * 
	 */
	def void translateAndSolveEquationsWithChoco(List<Triplet<List<String>, List<String>, List<String> >> listOfEquations,
												 List<Triplet<List<String>, List<String>, List<String>>> testPool){
		
		val chocoModel = new ProblemChoco() //choco model
		val integerVarOveralList = new ArrayList< List<IntegerVariable>>
		val listOfSubIdentifiers = new ArrayList<String> //
		var starIdent= 1 //
		
		for(equations: listOfEquations){
			
			listOfSubIdentifiers.addAll(equations.third)//
			
			if(equations != listOfEquations.last){
				listOfSubIdentifiers.add("#")//
			}
			
			val integerVarList = new ArrayList<IntegerVariable> //array of listOfEquations' "IntegerVariables"
			
			val variables = equations.first //variables in the triplet
			val values = equations.second //corresponding values of the variables 
			val subIdentifier =  equations.third //boolean expression identifier 
			
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
			val condExpression = listOfBooleanExpression.get(subIdentifier.extractIdentifier.parseInt)
			val chocoExpression = chocoIntegerExpression(condExpression, chocoModel, integerVarList)
			
			val equationResult = values.get(0) //the first element of the values' list is the result of the boolean expression
			val chocoResultVariable = variables.get(0).getChocoIntegerVar(integerVarList)
			
			//create constraints with choco
		 	if(equationResult == "T"){
				if (size == 1){ 
					//Here the size of the variable list is 1. 
					//That means that the variable is assigned with a boolean constant value ('true' or 'false')
					val constraint = chocoModel.eq(chocoExpression , chocoResultVariable) //
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
					if(equationResult == "*"){
						////////////////
						val constraint = chocoModel.eq(chocoExpression , chocoResultVariable)
						//Add constraints
						chocoModel.addConstraint(constraint)
					}
					else{
						throw new Exception("unknown value")	
					}
				}
			}//else
			
		}//for equations
	
		val solve = chocoModel.solve
		
	 	if(solve){
			
			System.out.println("Identifiers are: " + listOfSubIdentifiers.toString)
			System.out.println
			
			for(list: integerVarOveralList){
				for(intVar: list){
					System.out.println( intVar.getName() + ": "+ chocoModel.getIntValue(intVar));
				}
				System.out.println
			}
			System.out.println("######################")
			System.out.println
		
			addToTestPool(chocoModel, testPool, integerVarOveralList, listOfSubIdentifiers)
		}
		else{
			//System.out.println("Infeasible")
		}
		
	}//translateAndSolveEquationsWithChoco
	
	
	/**
	 * 
	 */
	def private void addToTestPool(ProblemChoco pb, List<Triplet<List<String>, List<String>, List<String>>> testPool, 
									List< List<IntegerVariable> > listOfIntegerVars, List<String> listOfsubIdentifiers){
		
		val listOfVariables = new ArrayList<String>
		var valueToAdd = "" //new ArrayList<String>
		
		for(list: listOfIntegerVars){
			
			for(intVar: list){
				val intVarName = intVar.getName()
				if(intVarName.charAt(0).toString == "*"){
					listOfVariables.add("*")
				}
				else{
					listOfVariables.add(intVarName)
				}
				
				valueToAdd = valueToAdd + pb.getIntValue(intVar).convertToBooleanChar
			}//for
			
			if(list != listOfIntegerVars.last){//Add the separator '#'
				listOfVariables.add("#")
				valueToAdd = valueToAdd + "#"
			}
		
		}//for
	
		//add
		val target = testPool.findFirst[it.first.equals(listOfVariables) && it.third.equals(listOfsubIdentifiers)]
		
		if(target != null){
			target.second.add(valueToAdd)
		}
		else{
			throw new Exception("Cannot find a target where to add a test case")
		}
	
	}//addToTestPool
	
	
	/**
	 * 
	 */
	def private Object getChocoIntegerVar(String str, List<IntegerVariable> list){
	 	for(e: list){
	 		if(e.name == str){
	 			return e
	 		}
	 	}
	 	throw new Exception("Error choco")
	 }//getChocoIntegerVar
	 
	 /**
	  * 
	  */
	  def private keepOnlyMcdcValues(Set<String> values, int identifier){
	  	val myMcdcValues = listOfMcdcValues.get(identifier)
	  	val newValues = values.filter[myMcdcValues.contains(it)]
	  	return newValues.toSet
	  }
	 
}//class
package org.xtext.generator

import java.util.List
import org.xtext.helper.Triplet
import java.util.ArrayList
import org.xtext.moduleDsl.MODULE_DECL
import org.xtext.moduleDsl.AbstractVAR_DECL
import org.xtext.moduleDsl.IF_STATEMENT
import org.xtext.moduleDsl.ASSIGN_STATEMENT
import org.xtext.moduleDsl.ERROR_STATEMENT
import org.xtext.moduleDsl.LOOP_STATEMENT
import static extension org.xtext.generator.MCDC_GeneratorUtils.*
import org.xtext.optimization.optimStrategy1
import org.xtext.helper.Couple

class MCDC_Module {
	
	val mcdcStatement = new MCDC_Statement()
	val optim = new optimStrategy1()
	
	def enumerateAllModulePaths(MODULE_DECL module){
		val allStatements = module.body.statements
		var List<List<Triplet <List<String>, List<String>, List<String> >>> result = new ArrayList<List<Triplet <List<String>, List<String>, List<String> >>>
		
		for(st: allStatements){
			switch(st){
				
				AbstractVAR_DECL: {
					val triplet = mcdcStatement.mcdcVarStatement(st)
					if(triplet != null){
						result = mergePaths(result, triplet.tripletToListOfList)
					}
				}//AbstractVAR_DECL
				
				ASSIGN_STATEMENT: {
					val triplet = mcdcStatement.mcdcAssignStatement(st)
					if(triplet != null){
						result = mergePaths(result, triplet.tripletToListOfList)
					}
				}//ASSIGN_STATEMENT
				
				IF_STATEMENT: {
					result = mergePaths(result, mcdcStatement.mcdcIfStatement(st))
				}//IF_STATEMENT
				
				ERROR_STATEMENT:{
					//nothing to do
				}//ERROR_STATEMENT
				
				LOOP_STATEMENT:{
					//To be implemented later
				}//LOOP_STATEMENT
				
			}//switch
		}//for
		
		System.out.println("Size is: " + result.size)
		
		val result2 = result.copyListOfList
		result2.staticSingleAssignment
		
		System.out.println("####### MODULES PATHS #######")
		for(r: result2){
			System.out.println("{")
			
			for(rr: r){
				System.out.print(rr.first.toString + " => ")
				System.out.print(rr.second.toString + " => " )
				System.out.println(rr.third.toString )
			}
			
			System.out.println("}")
			System.out.println
		}
		
 	/* 	//concat mcdc values
		System.out.println
		System.out.println("####### TEST SUITES #######")
		val concatResult = mcdcStatement.concatMcdcValues2(result2)	
			for(cr: concatResult){
				System.out.print(cr.first.toString + " => ")
				System.out.print(cr.second.toString + " => " )
				System.out.println(cr.third.toString )
				System.out.println
			}
		System.out.println
		System.out.println("####### COVERAGE RESULT #######")
		val splitResult = mcdcStatement.splitConcatenatedValues(concatResult)
			for(sr: splitResult){
				System.out.print(sr.first.toString + " => ")
				System.out.print(sr.second.toString + " => " )
				System.out.println(sr.third.toString )
				System.out.println
			}
		val notCoveredValues = mcdcStatement.notCoveredValues(splitResult)
		System.out.println
		System.out.println("####### NOT COVERED ####### ")
		for(nc: notCoveredValues){
				System.out.print(nc.first.toString + " => ")
				System.out.print(nc.second.toString + " => " )
				System.out.println(nc.third.toString )
				System.out.println
		}
		
	 	val listOfEquations = mcdcStatement.buildEquations(notCoveredValues, result2)
		System.out.println
		System.out.println ("####### EQUATIONS ####### ")
		
		for(eq: listOfEquations){
			System.out.println("{")
			
			for(rr: eq){
				System.out.print(rr.first.toString + " => ")
				System.out.print(rr.second.toString + " => " )
				System.out.println(rr.third.toString )
			}
			
			System.out.println("}")
			System.out.println
		}
		
		System.out.println("####### Solving... #######")
		for(equations: listOfEquations){
			mcdcStatement.translateAndSolveEquationsWithChoco(equations, concatResult)
		} 
		
		System.out.println("####### NEW TEST SUITES... #######")
		System.out.println
			for(cr: concatResult){
				if(cr.second.size > 0){
					System.out.print(cr.first.toString + " => ")
					System.out.print(cr.second.toString + " => " )
					System.out.println(cr.third.toString )
					System.out.println	
				}
			}
		System.out.println
		
		System.out.println
		System.out.println("####### COVERAGE RESULT #######")
		val splitResult1 = mcdcStatement.splitConcatenatedValues(concatResult)

			for(sr: splitResult1){
				System.out.print(sr.first.toString + " => ")
				System.out.print(sr.second.toString + " => " )
				System.out.println(sr.third.toString )
				System.out.println
			}
		val notCoveredValues2 = mcdcStatement.notCoveredValues(splitResult1)
		System.out.println
		System.out.println("####### NOT COVERED ####### ")
		for(nc: notCoveredValues2){
				System.out.print(nc.first.toString + " => ")
				System.out.print(nc.second.toString + " => " )
				System.out.println(nc.third.toString )
				System.out.println
		}
		
		/*val splitResult11 = mcdcStatement.mergeCoverageResults(splitResult1)
		System.out.println
		System.out.println("####### MERGED RESULTS ####### ")
		for(sr: splitResult11){
				System.out.print(sr.first.toString + " => ")
				System.out.print(sr.second.toString + " => " )
				System.out.println(sr.third.toString )
				System.out.println
		}
		
		System.out.println
		System.out.println("####### VECTORS ####### ")
		optim.optimize(concatResult, mcdcStatement.mcdcvalues,notCoveredValues2)
		//return result */
	}//enumerateAllModulePaths
	
	def private tripletToListOfList(Triplet <List<String>, List<String>, List<String> > triplet){
		val tmp = new ArrayList<Triplet <List<String>, List<String>, List<String> >>
		tmp.add(triplet)
		val List<List<Triplet <List<String>, List<String>, List<String> >>> tmpList = new ArrayList<List<Triplet <List<String>, List<String>, List<String> >>>
		tmpList.add(tmp)
		return tmpList
	}//tripletToListOfList
	
	def private mergePaths(List<List<Triplet <List<String>, List<String>, List<String> >>> list1, List<List<Triplet <List<String>, List<String>, List<String> >>> list2){
		
		val result = new ArrayList<List<Triplet <List<String>, List<String>, List<String> >>>
		
		val size1 = list1.size
		val size2 = list2.size
		
		if (size2 == 0){
			throw new Exception("Invalid argument")
		}
		else{//list2 is not empty
			if( size1 == 0){
				return list2
			}
			else{//list1 is not empty and list2 is not empty
				for(e1: list1){
					for(e2: list2){
						val tmpList = new ArrayList<Triplet <List<String>, List<String>, List<String> >>
						
						tmpList.addAll(e1)
						tmpList.addAll(e2) //tmpList now contains 'e1 + e2'
	
						result.add(tmpList)
					}//for
				}//for
			}	
		}//else
		
		return result
	}//mergePaths
	
	def staticSingleAssignment(List<List<Triplet <List<String>, List<String>, List<String>>>> listOfList){
		
		for(list : listOfList){
					
			val defList = new ArrayList<Couple<String, Integer>>	
			
			for(triplet : list){ 
				val useList = new ArrayList<Couple<String, Integer>>
				//compute useList
				
				val identifier = triplet.third.extractIdentifier
				val identifierIndex = triplet.third.extractIdentIndex
				
				if(identifierIndex == "N"){//non boolean expression
					val varInExpression = mcdcStatement.listOfVarInNonBoolExpression.get(identifier.parseInt)
					useList.initUseList(varInExpression) //
					useList.updateUseList(defList)
					
					//replace use variables by theirs new names
					if(useList.size != 0){
						val expression = mcdcStatement.listOfNonBooleanExpression.get(identifier.parseInt)
						val renamedList = new ArrayList<String>
						renameVarInBoolExpression(expression, useList, renamedList)
						
						System.out.println
						System.out.println("Renamed list: " + renamedList.toString)  
						System.out.println
						
						triplet.setSecond(renamedList)//
					}
					
					val assignVar = triplet.first.get(0)
					if(assignVar != "*"){
						val defCouple = defList.updateDefList(assignVar)
						//replace the assignVar by a new name (i.e 'assignVar + index')
						triplet.first.set(0, defCouple.first + defCouple.second)
					}
					
				}
				else{//identifierIndex == "F" or "T" or "X"
					val varInExpression = mcdcStatement.listOfVarInBoolExpression.get(identifier.parseInt)
					useList.initUseList(varInExpression) //varInExpression may be null
					useList.updateUseList(defList)
					
					//replace use variables by theirs new names
					if(useList.size != 0){
						val expression = mcdcStatement.listOfBooleanExpression.get(identifier.parseInt)
						val renamedList = new ArrayList<String>
						renameVarInBoolExpression(expression, useList, renamedList)
						
						System.out.println
						System.out.println("Renamed list: " + renamedList.toString)  
						System.out.println
						
						triplet.setFirst(renamedList)//
					}
					
					val assignVar = triplet.first.get(0)
					if(assignVar != "*"){
						val defCouple = defList.updateDefList(assignVar)
						//replace the assignVar by a new name (i.e 'assignVar + index')
						triplet.first.set(0, defCouple.first + defCouple.second)
					}
				}
			}
		}
	}
	
	
	def initUseList(List<Couple<String,Integer>> useList, List<String> list) {
		list.forEach[ 
			elem | useList.add( new Couple(elem, -1))
		]
	}
	
	def updateUseList(List<Couple<String,Integer>> useList, List<Couple<String,Integer>> previousDefList){
		useList.forEach[ 
			use | previousDefList.forEach[ 
				previousDef | if(use.first == previousDef.first){ /*replace the second*/use.setSecond(previousDef.second) }
			]
		]
	}
	
	def updateDefList(List<Couple<String,Integer>> defList, String assignVar) {
		
		for(defCouple: defList) { 
			if (defCouple.first == assignVar){ 
				val value = defCouple.second 
				defCouple.setSecond(value.intValue + 1)
				return defCouple
			}
		}
		val newCouple = new Couple(assignVar, 0)
		defList.add(newCouple)
		return newCouple
	}

}//class
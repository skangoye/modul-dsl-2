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

class MCDC_Module {
	
	val mcdcStatement = new MCDC_Statement()
	
	def enumerateAllModulePaths(MODULE_DECL module){
		val allStatements = module.body.statements
		var List<List<Triplet <List<String>, List<String>, String>>> result = new ArrayList<List<Triplet <List<String>, List<String>, String>>>
		
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
		result2.assignVariableIdentifier
		
		System.out.println("####### MODULES PATHS #######")
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
		val concatResult = mcdcStatement.concatMcdcValues(result2)	
			for(cr: concatResult){
				System.out.print(cr.first.toString + " => ")
				System.out.print(cr.second.toString + " => " )
				System.out.println(cr.third)
				System.out.println
			}
		System.out.println
		System.out.println("####### COVERAGE RESULT #######")
		val splitResult = mcdcStatement.splitConcatenatedValues(concatResult)
			for(sr: splitResult){
				System.out.print(sr.first.toString + " => ")
				System.out.print(sr.second.toString + " => " )
				System.out.println(sr.third)
				System.out.println
			}
		val notCoveredValues = mcdcStatement.notCoveredValues(splitResult)
		System.out.println
		System.out.println("####### NOT COVERED ####### ")
		for(nc: notCoveredValues){
				System.out.print(nc.first.toString + " => ")
				System.out.print(nc.second.toString + " => " )
				System.out.println(nc.third)
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
				System.out.println(rr.third)
			}
			
			System.out.println("}")
			System.out.println
		}
		
		System.out.println("####### Solving... #######")
		for(equations: listOfEquations){
			mcdcStatement.translateAndSolveEquationsWithChoco(equations)
		} 
		
		//return result
	}//enumerateAllModulePaths
	
	def private tripletToListOfList(Triplet <List<String>, List<String>, String> triplet){
		val tmp = new ArrayList<Triplet <List<String>, List<String>, String>>
		tmp.add(triplet)
		val List<List<Triplet <List<String>, List<String>, String>>> tmpList = new ArrayList<List<Triplet <List<String>, List<String>, String>>>
		tmpList.add(tmp)
		return tmpList
	}//tripletToListOfList
	
	def private mergePaths(List<List<Triplet <List<String>, List<String>, String>>> list1, List<List<Triplet <List<String>, List<String>, String>>> list2){
		
		val result = new ArrayList<List<Triplet <List<String>, List<String>, String>>>
		
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
						val tmpList = new ArrayList<Triplet <List<String>, List<String>, String>>
						
						tmpList.addAll(e1)
						tmpList.addAll(e2) //tmpList now contains 'e1 + e2'
	
						result.add(tmpList)
					}//for
				}//for
			}	
		}//else
		
		return result
	}//mergePaths

}//class
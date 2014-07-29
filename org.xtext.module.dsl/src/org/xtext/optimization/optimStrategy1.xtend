package org.xtext.optimization

import java.util.List
import org.xtext.helper.Triplet
import org.xtext.helper.Couple
import java.util.ArrayList
import static extension org.xtext.generator.MCDC_GeneratorUtils.*

class optimStrategy1 {
	
	def optimize(List<Triplet<List<String>, List<String>, List<String>>> testsPool, List<List<String>> listOfMcdcValues, List<Triplet<List<String>,List<String>, List<String>>> listOfNotCoveredValues){
		val coverageMatrix = makeCoverageMatrix(listOfMcdcValues, listOfNotCoveredValues)
		val vectorBasis = vectorsBasis(coverageMatrix)
		val testsRepr  = decompositionOfTests(testsPool)
		val vectorsList = vectorReprOfTests(coverageMatrix, testsRepr)
		vectorsList.checkVectorsConsistency
		System.out.println("Basis: "+ vectorBasis.toString )
		System.out.println("Here, I am: " + vectorsList.toString)
	}//optimize
	
	def private makeCoverageMatrix(List<List<String>> listOfMcdcValues, List<Triplet<List<String>,List<String>, List<String>>> listOfNotCoveredValues){
		val listOflistOfCouples =  new ArrayList < List<Couple<String, String>> >
		listOfMcdcValues.forEach[ e | 
			val listOfCouples = new ArrayList<Couple<String, String>> 
			e.forEach[ v | listOfCouples.add(new Couple(v ,"0"))]
			listOflistOfCouples.add(listOfCouples)
		]
		
		for(triplet:listOfNotCoveredValues){
			
			val identifier = triplet.third.extractIdentifier.parseInt 
			val targetValues = listOflistOfCouples.get(identifier) //mcdc values of the identifier "identifier"
			val values = triplet.second
			
			values.forEach[ 
				v | val find = targetValues.findFirst[it.first == v]
				if (find != null) {
					find.setSecond("-")
				}
			]
		}//for
	
		return listOflistOfCouples
	
	}//initcoverageMatrix
	
	def private vectorsBasis(List<List<Couple<String,String>>> coverageMatrix){
		val vectorBasis = new ArrayList<String>
		coverageMatrix.forEach[
			list | list.forEach[
				couple | val value = couple.first
						 val vectorAttr = couple.second
				if(vectorAttr != "-"){
					vectorBasis.add(value)
				}
			]
		]
		return vectorBasis
	}
	
	def private decompositionOfTests(List<Triplet<List<String>, List<String>, List<String>>> testsPool){
		val testsRepr = new ArrayList<List<Couple<String,String>>>
		testsPool.forEach[
			triplet | val values = triplet.second
					  val identSequence = triplet.third
			values.forEach[ 
				test | val decompositionOfTest = new ArrayList<Couple<String,String>>
					   val indexOfIdents = identSequence.indexesBeforeSeparator
					   val testToArray = test.toStringArray
					   val indexOfTest = testToArray.indexesBeforeSeparator
					   
					   val size = indexOfTest.size
					   
					   if(size != indexOfIdents.size){
					   	 	throw new Exception("Size mismatch")
					   }
					   
					   var i = 0
					   do{
					   	 	val testLeftIndex = indexOfTest.get(i).first
							val testRigthIndex = indexOfTest.get(i).second
				
							val identLeftIndex = indexOfIdents.get(i).first
							val identRightIndex = indexOfIdents.get(i).second
							
							val ident = identSequence.subList(identLeftIndex, identRightIndex + 1).extractIdentifier
							val subTest = testToArray.subList(testLeftIndex, testRigthIndex + 1)
							
							decompositionOfTest.add( new Couple(subTest.arrayToString, ident))
				
					   }while( (i=i+1) < size )
			
				testsRepr.add(decompositionOfTest)
			]
		]
		return testsRepr
	}//decompositionOfTests
	
	def private vectorReprOfTests(List<List<Couple<String,String>>> coverageMatrix, List<List<Couple<String,String>>> decompositionOfTests){
		
		val vectorList = new ArrayList<String> 
		
		decompositionOfTests.forEach[
			test | test.forEach[
					couple | val identifier = couple.second.parseInt
							 val value      = couple.first
							 coverageMatrix.get(identifier).forEach[
							 	pair | if (pair.first == value){
							 				pair.setSecond("1")
							 		   }
							 ]
			]
			vectorList.add(coverageMatrix.getVector)
			coverageMatrix.init
		]
		return vectorList	
	}

	def private void checkVectorsConsistency(List<String> vectorList){
		val vectorSize = vectorList.get(0).length
		for(vector: vectorList){
			if(vector.length != vectorSize){
				throw new Exception("Vector size mismatch")
			}
		}
	}
	
	def private void init(List<List<Couple<String,String>>> coverageMatrix){
		for (listOfCouple : coverageMatrix){
			 for (couple : listOfCouple){ 
				val vectorElem = couple.second
				if(vectorElem == "1"){
					couple.setSecond("0")
				}
			}
		}
	}//init
	
	def private getVector(List<List<Couple<String,String>>> coverageMatrix){
		var vector = ""
		for (listOfCouple : coverageMatrix){
			 for (couple : listOfCouple){ 
				val vectorElem = couple.second
				if(vectorElem != "-"){
					vector = vector + vectorElem
				}
			}
		}
		return vector
	}//getVector
	
	def testSuiteReduction(List<String> vectorsList){
		
		//
		val reducedTestsSuit = new ArrayList<String>
		
		
		//initialize contribution values
		val size = vectorsList.size
		var contribution = 0
		var index = -1
		val nullVector = nullVector(size)
		
		var cpt = 0
		do{
			val currVector = vectorsList.get(cpt)
			val tmpContrib = contribution(nullVector, currVector)
			
			if(tmpContrib > contribution){
				contribution = tmpContrib
				index = cpt
			}
		
		} while( (cpt=cpt+1) < size )
		
		//At this point, the higher contribution value is 'contribution' and the index of the vector is 'index'
		
		val firstVector = vectorsList.get(index)
		reducedTestsSuit.add(firstVector)
	
	
	}//testSuiteReduction
	
	def private nullVector(int i) {
		var vector = ""
		var cpt = 0
		do{
			vector = vector + "0"
		} while( (cpt=cpt+1) < i)
		return vector
	}
	
	//testSuiteReduction
	
	def private contribution(String vector1, String vector2){
		
		var count = 0
		
		if(vector1.length != vector2.length){
			throw new Exception("The two vectors must have the same length")
		}
		
		val vectorArray1 = vector1.toStringArray
		val vectorArray2 = vector2.toStringArray
		
		var size = vectorArray1.size
		
		var i = 0
		do{
			if( (vectorArray1.get(i).parseInt - vectorArray2.get(i).parseInt) < 0 ){
				count = count + 1
			}
		} while( (i=i+1) < size)
		
		return count
	}//contribution
	
	//vectorReprOfTests
}
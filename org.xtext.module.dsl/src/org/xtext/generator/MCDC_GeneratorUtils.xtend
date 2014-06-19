package org.xtext.generator

import java.util.List
import java.util.ArrayList

import org.xtext.helper.Couple
import org.xtext.helper.Triplet
import org.xtext.moduleDsl.EXPRESSION
import org.xtext.moduleDsl.AND
import org.xtext.moduleDsl.OR
import org.xtext.moduleDsl.EQUAL_DIFF
import org.xtext.moduleDsl.NOT
import org.xtext.moduleDsl.COMPARISON
import org.xtext.moduleDsl.VarExpRef
import org.xtext.moduleDsl.ADD
import org.xtext.moduleDsl.SUB
import org.xtext.moduleDsl.MULT
import org.xtext.moduleDsl.DIV
import org.xtext.moduleDsl.intConstant
import org.xtext.moduleDsl.realConstant
import org.xtext.moduleDsl.strConstant
import org.xtext.moduleDsl.enumConstant
import org.xtext.moduleDsl.boolConstant
import org.xtext.moduleDsl.bitConstant
import org.xtext.moduleDsl.hexConstant

class MCDC_GeneratorUtils {
	
	  /**
	   * 
	   */
	  def static unknownStringVector(int length){
	  	if(length < 1){
	  		throw new Exception("The length has to be greater than 0")
	  	}
	  	
	  	var i =0
	  	var tmpStr = ""
	  	do {
	  		tmpStr = tmpStr + "*"
	  	}while ( (i=i+1) < length)
	  	
	  	return tmpStr
	  }
	
	
	  /**
	   * 
	   */
	  def static String setCharAt(String str, int index, char r){
	  		val size = str.length
	  		
	  		if(index >= size){
	  			throw new Exception("Index Out of range")
	  		}
	  		
	  		val toCharList = str.toCharArray
	  		toCharList.set(index, r)
	  		
	  		var newStr = ""
	  		
	  		for (e: toCharList){
	  			newStr = newStr + e.toString
	  		}

			return newStr	 		
	  }
	  
	/**
	  * Checks whether two lists have common elements 
	  * @param list1: list of String
	  * @param list2: list of string
	  * @return list: A list of common elements except special characters '#' and '*'
	  */
	  def static List<String> intersectionOfLists(List<String> list1, List<String> list2){
	  	val commonList = new ArrayList<String>
	  	
	  	if (list1.size == 0 || list2.size == 0 ){
	  		return commonList
	  	}
	  	
	  	for (i:list1){
	  		for (j:list2){
	  			if ( i == j && j != "*" && j != "#"){
	  				commonList.add(j)
	  			}
	  		}
	  	}
	  	return commonList
	  }
	  
	  /**
	  * store the indexes of common elements of list1 and list2
	  * @param list1: list of String
	  * @param list2: list of string
	  * @return list: A list of common elements except special characters '#' and '*'
	  */
	   def static List<Couple<Integer,Integer>> indexOfCommonVars(List<String> list1, List<String> list2){
	  	val commonList = new ArrayList<Couple<Integer,Integer>>
	  	
	  	if (list1.size == 0 || list2.size == 0 ){
	  		return commonList
	  	}
	  	
	  	var i = 0
	  	val size1 = list1.size
	  	val size2 = list2.size
	  	do{
	  		val e1 = list1.get(i)
	  		var j = 0
	  		do{
	  			val e2 = list2.get(j)
	  			if ( (e1 != "*") && (e1 != "#") && (e2 != "*") && (e2 != "#") ){
	  				if( e1 == e2){
	  					commonList.add(new Couple(i,j))
	  				}	
	  			}
	  		} while((j=j+1) < size2)
	  		
	  	} while ((i=i+1) < size1)
	  	
	  	return commonList
	  }
	  
	/**
	 * This method deletes the last character of a string and returns the new string
	 * @param str The subject string i.e the string we want to delete its last character
	 * @return substring of the str without its last character
	 */
	def static String deleteLastChar(String str){
		val strSize = str.length
		var myStr = ""
		if(strSize > 0){
			myStr = str.substring(0, strSize-1)
		}
		return myStr
	}
	
	/**
	 * delete the first string's character and returns a new string 
	 */
	def static String deleteFisrtChar(String str){
		val strSize = str.length
		var myStr = ""
		if(strSize > 0){
			myStr = str.substring(1)
		}
		return myStr
	}
	
	/**
	 * returns the last character of a given string. If the string is empty it returns an empty string
	 */
	def static String getLastChar(String str){
		val strSize = str.length
		var myStr = ""
		if (strSize > 0){
		 	 myStr = str.charAt(strSize-1).toString
		}
		return myStr
	}
	
	/**
	 * 
	 */
	def static indexesBeforeSeparator(List<String> list){
		val indexes = new ArrayList<Couple<Integer,Integer>>
		val size = list.size
		var cpt = 0
		var currentIndex = 0
		
		for(str: list){
			if(str == "#"){
				indexes.add( new Couple(cpt,currentIndex-1))
				cpt = currentIndex + 1
			}
			
			if(currentIndex == (size - 1)){
				indexes.add( new Couple(cpt,size-1))
			}
			currentIndex = currentIndex + 1
		}
		return indexes
	}
	
	/**
	 * Parse a given string to an 'int' value
	 * @param 
	 * 		str valid String to be parsed
	 * @return 
	 * 		Integer corresponding to the string 'str' value
	 */
	def static parseInt(String str){
		return Integer.parseInt(str)
	}
	
	/**
	 * Lists all elements of 'list1' that are not in 'list2'
	 *  @param 
	 * 			list1
	 * 			list2
	 * @return all elements in list1 that are not in list2
	 */
	def static listDiff(List<String> list1 , List<String> list2){
		val List<String> list = new ArrayList<String>
		for(e1:list1){
			if (! list2.contains(e1) ){
				list.add(e1)
			}
		}//for
		return list
	}
	
	/**
	 * Converts a String to a new String array
	 */
	 def static toStringArray(String str){
	 	val charArray = str.toCharArray
	 	val toStringArray = new ArrayList<String>
	 	charArray.forEach[c | toStringArray.add(c.toString)]
	 	return toStringArray
	 }
	
	/**
	 * 
	 */
	def static copyListOfList(List<List<Triplet <List<String>, List<String>, List<String> >>> listOfList){
		
		val copyListOfList = new ArrayList<List<Triplet <List<String>, List<String>, List<String>>>> 
		
		for(list: listOfList){
			
			val copyList = new ArrayList<Triplet <List<String>, List<String>, List<String>>>
			
			for(triplet: list){		
				copyList.add(new Triplet(triplet.first.copyList, triplet.second.copyList, triplet.third.copyList)) 
			}//for
			
			copyListOfList.add(copyList)
		}
		return copyListOfList
	}
	
	/**
	 * 
	 */
	 def static copyListOfTriplet(List<Triplet <List<String>, List<String>, List<String>>> listOfTriplet){
	 	
	 	val copyList = new ArrayList<Triplet <List<String>, List<String>, List<String>>>
			
			for(triplet: listOfTriplet){		
				copyList.add(new Triplet(triplet.first.copyList, triplet.second.copyList, triplet.third.copyList)) 
			}//for
			
			return copyList
	 }
	
	/**
	 * 
	 */
	def static shrinkList(List<List<Triplet <List<String>, List<String>, String>>> listOfList){ ////////////////////////a revoir
		
		var i = 0
		var size = listOfList.size
		do{
	  		val list1 = listOfList.get(i)
	  		val size1 = list1.size
	  		var j = 0
	  		do{
	  			val list2 = listOfList.get(j)
	  			
	  			val size2 = list2.size
	  			
	  			if((i != j) && (size1 == size2)){
	  				
	  				val identsOfList1 = new ArrayList<String>
					val identsOfList2 = new ArrayList<String>
					list1.forEach[t | identsOfList1.add(t.third)]
					list2.forEach[t | identsOfList2.add(t.third)]
					
					if(identsOfList1.equals(identsOfList2)){
						val newlist = new ArrayList<String>
						newlist.addAll(list1.get(size1-1).second)
						newlist.addAll(list2.get(size2-1).second)
						list1.get(size1-1).setSecond(newlist)
						listOfList.remove(list2)
						j = j - 1
						size = listOfList.size
					}
					
	  			}//if
	  		}while((j=j+1) < size)
	  		
	  	} while ((i=i+1) < size)
	}
	
	/**
	 * 
	 */
	def private static countElements(String str, List<String> list){
		var count = 0
		
		if(list.size == 0){
			return 0
		}
		
		for(e : list){
			if(str == e){
				count = count + 1
			}
		}
		return count
	}
	
	/**
	 * 
	 */
	def static extractIdentifier(List<String> ident) {
		
		if(ident.size != 1){
			throw new Exception("Incorrect number of identifiers")
		}
		else{
			return ident.get(0).deleteLastChar
		}
	}
	
	/**
	 * 
	 */
	def private static setValues(List<String> list, String value, String setValue){
		
		var size = list.size
		if(size==0){
			throw new Exception 
		}
		var i = 0
		do {
			if((list.get(i)==value) && (i != 0)){
				list.set(i, setValue)
			}
		} while((i=i+1)<size)
	}
	
	/**
	 * 
	 */
	def static assignVariableIdentifier(List<List<Triplet <List<String>, List<String>, List<String> >>> listOfList){
		for(list: listOfList){
			
			var listOfAssignVariables = new ArrayList<String>
			
			var size = list.size
			var i = 0
			do{
				val listOfVariables = list.get(i).first
				val assignmentVariable = listOfVariables.get(0)
				if( (assignmentVariable != "*")){
					val count = assignmentVariable.countElements( listOfAssignVariables )
					val newVariable = assignmentVariable + "@" + count.toString
					listOfAssignVariables.add(assignmentVariable)
					listOfVariables.set(0, newVariable)
					
					var j = i + 1
					do{
						if (j != size){
							val followingVariables = list.get(j).first
							if(followingVariables.contains(assignmentVariable)){
							
								followingVariables.setValues(assignmentVariable, newVariable)
							
								if(followingVariables.get(0) == assignmentVariable){
									j = size //exit the loop
								}//if
						
							}//if
						}//if
						
					} while ((j=j+1) < size) 
				}
			
			}while((i=i+1) < size)	
		
		}
	}
	
	
	/**
	 * Stores in a list, all the variables that are involved in an expression
	 * Note: A relational condition (e.g (a<4)) is considered as a single variable
	 * @param expression The expression in which we want to extract the variables
	 * @param list All the variables will be stored in this list
	 */
	 def static void varInExpression(EXPRESSION expression, List<String> list){
	 	switch(expression){
	 		AND: {varInExpression(expression.left, list) varInExpression(expression.right, list)}
	 		OR: {varInExpression(expression.left, list) varInExpression(expression.right, list)}
	 		EQUAL_DIFF: list.add(relBoolRepr(expression.left) + expression.op + relBoolRepr(expression.right)) 
	 		NOT: varInExpression(expression.exp, list)
	 		COMPARISON: list.add(relBoolRepr(expression.left) + expression.op + relBoolRepr(expression.right)) 
	 		VarExpRef: list.add(expression.vref.name)
	 	}
	 }
	 
	 /**
	  * Sub-method of the method 'stringReprOfVar'; It deals specially with relational
	  * conditions
	  * @param expression Expression to be represented in string form
	  * @return A string that represents the relational condition
	  */
	  def static String relBoolRepr(EXPRESSION expression){
	  	switch(expression){
	  		ADD: "(" + relBoolRepr(expression.left)+ "+" +  relBoolRepr(expression.right) +")"
	  		SUB: "(" + relBoolRepr(expression.left)+ "-" +  relBoolRepr(expression.right) +")"
	  		MULT:"(" + relBoolRepr(expression.left)+ "*" +  relBoolRepr(expression.right) +")"
	  		DIV: "(" + relBoolRepr(expression.left)+ "/" +  relBoolRepr(expression.right) +")"
	  		intConstant: expression.value.toString
	  		realConstant:expression.value.toString
	  		strConstant: expression.value.toString
	  		enumConstant: expression.value.toString
	  		boolConstant: expression.value.toString
	  		bitConstant: expression.value.toString
	  		hexConstant: expression.value.toString
	  		VarExpRef: expression.vref.name.toString
	  		default:""
	  	}
	  }
	  
	  /**
	 * Checks whether two given strings form an independent pair
	 * @param str1 first string value
	 * @param str2 second string value
	 * @return returns 'True' if two strings form an independent pair, 'False' otherwise
	 */
	def static boolean independantPairs(String str1, String str2) {
		
		val a1 = str1.toCharArray
		val a2 = str2.toCharArray
		val size = str1.length
		
		var a =  ""
		var compatible = false
		var index = -1
		
		if(str1 == str2){
			throw new Exception("Illegal arguments")
		}
		else{
			
			var i =0
			do{	 
				if( a1.get(i) == a2.get(i) ){
					a = a + "0"
				}
				else{
					a = a + "1"
				}
				
			}while( (i=i+1) < size)
			
			var j =0
			var cnt = 0
			var asize = a.length
			//System.out.println(a)
		
			do{
				if(a.charAt(j).toString() == "1"){
					cnt = cnt + 1
					index = j
				}
			} while((j=j+1) < asize)
			
			if(cnt == 1){
				//str1 at cp1 first param compatible with str2 at cp2 first param
				compatible = true;
				//list.add(new Couple (str1,str2))
				
			}
	
		}//else
		return compatible
	}
	/**
	 * 
	 */
	 def static normalizedName(String variable){
	 	var tmp = ""
	 	val strArray = variable.toStringArray
	 	
	 	for(current : strArray){
	 		if(current == "@"){
	 			return tmp
	 		}
	 		tmp = tmp + current
	 	}//for
	 	
	 	return variable
	 }
	 
	/**
	 * Copy the elements of the list 'list' in a new list
	 * @param list the subject list
	 * @return The new list with copied elements
	 */
	def static <T> copyList(List<T> list){
		val List<T> copy = new ArrayList<T>
		for(e: list){
			copy.add(e)
		}
		return copy
	}
	
	/**
	 * Transform a list of Couple (String1,String2) into a list of (String) following this rule:
	 * 'String = String2 + String1'
	 * @ param list
	 * 				list of Couple of (String1,String2)
	 * @return List of String w.r.t the rule
	 */
	def static List<String> reduceList( List<Couple<String, String>> list){
		val listOfString = new ArrayList<String>
		list.forEach[ t | listOfString.add(t.second + t.first)]
		return listOfString
	}
	
	/**
	 * Checks whether at least 2 list of variables involved in the list of triplet have some variables in common
	 */
	def static boolean noVarInCommon(List<Triplet<List<String>,List<String>, List<String> >> list){
		var cumulList = new ArrayList<String>
		for(e:list){
			val varList = e.first
			if( intersectionOfLists(cumulList, varList).size > 0) {
				return false
			}
			cumulList.addAll(varList)
		}
		return true
	}
}
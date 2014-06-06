package org.xtext.type.provider

import org.xtext.moduleDsl.EXPRESSION
import org.xtext.moduleDsl.intConstant
import org.xtext.moduleDsl.realConstant
import org.xtext.moduleDsl.strConstant
import org.xtext.moduleDsl.enumConstant
import org.xtext.moduleDsl.boolConstant
import org.xtext.moduleDsl.bitConstant
import org.xtext.moduleDsl.hexConstant
import org.xtext.moduleDsl.AND
import org.xtext.moduleDsl.OR
import org.xtext.moduleDsl.NOT
import org.xtext.moduleDsl.EQUAL_DIFF
import org.xtext.moduleDsl.COMPARISON
import org.xtext.moduleDsl.MULT
import org.xtext.moduleDsl.DIV
import org.xtext.moduleDsl.SUB
import org.xtext.moduleDsl.ADD
import org.xtext.moduleDsl.VarExpRef
import org.xtext.moduleDsl.AbstractVAR_DECL

class ExpressionsTypeProvider {
	public static val intType = 'integer'
	public static val realType = 'real'
	public static val boolType = 'boolean'
	public static val strType = 'string'
	public static val enumType = 'enumeration'
	public static val hexType = 'hexadecimal'
	public static val bitType = 'bit'
	
	def dispatch String typeFor(EXPRESSION e){
		
		switch(e){
			intConstant :  intType
	 		realConstant:  realType
	 		strConstant :  strType
	 		enumConstant:  enumType
	 		boolConstant:  boolType
	 		bitConstant :  bitType
	 		hexConstant :  hexType
	 		AND         :  boolType
	 		OR          :  boolType
	 		NOT         :  boolType
	 		EQUAL_DIFF  :  boolType
	 		COMPARISON  :  boolType
		}	
	}
	
	def dispatch String typeFor(MULT e){
		val leftType = e.left?.typeFor
		val rightType = e.right?.typeFor
		if (leftType == intType && rightType == intType){
			return intType
		}
		else{
			if (leftType == realType && rightType == intType || leftType == intType && rightType == realType || leftType == realType && rightType == realType){
				return realType
			}
			else{
				return null
			}
		}
		
	}
	
	def dispatch String typeFor(DIV e){
		val leftType = e.left?.typeFor
		val rightType = e.right?.typeFor
		if (leftType == intType && rightType == intType){
			return intType
		}
		else{
			if (leftType == realType && rightType == intType || leftType == intType && rightType == realType || leftType == realType && rightType == realType){
				return realType
			}
			else{
				return null
			}
		}
		
	}
	
	def dispatch String typeFor(SUB e){
		val leftType = e.left?.typeFor
		val rightType = e.right?.typeFor
		if (leftType == intType && rightType == intType){
			return intType
		}
		else{
			if (leftType == realType && rightType == intType || leftType == intType && rightType == realType || leftType == realType && rightType == realType){
				return realType
			}
			else{
				return null
			}
		}
		
	}
	
	def dispatch String typeFor(ADD e){
		val leftType = e.left?.typeFor
		val rightType = e.right?.typeFor
		if (leftType == intType && rightType == intType){
			return intType
		}
		else{
			if (leftType == realType && rightType == intType || leftType == intType && rightType == realType || leftType == realType && rightType == realType){
				return realType
			}
			else{
				if (leftType == strType && rightType == strType){
					return strType
				}
				else{
					if (leftType == bitType && rightType == bitType){
						return bitType
					}
					else{
						if (leftType == hexType && rightType == hexType){
							return hexType
						}
						else{
							return null
						}
					}
				}
			}
		}
		
	}
	
	def dispatch String typeFor(VarExpRef e){
		if (e.vref == null	){
			return null
		}
		else{
			e.vref.varTypeProvider
		}
		
		
	}
	
	def String varTypeProvider(AbstractVAR_DECL abstractVar) {
		val typ = abstractVar.type?.type
		switch typ {
			case typ=='int' : intType
			case typ=='real': realType
			case typ=='bool': boolType
			case typ=='enum': enumType
			case typ=='str' : strType
			case typ=='bit' : bitType
			case typ=='hex' : hexType
			default : null
			
		}
	}
	
	
	}
package org.xtext.solver

import org.xtext.moduleDsl.OR
import org.xtext.moduleDsl.AND
import org.xtext.moduleDsl.NOT
import org.xtext.moduleDsl.COMPARISON
import org.xtext.moduleDsl.EQUAL_DIFF
import org.xtext.moduleDsl.VarExpRef
import java.util.List
import org.xtext.moduleDsl.EXPRESSION

import static extension org.xtext.generator.MCDC_GeneratorUtils.*
import choco.kernel.model.variables.integer.IntegerVariable
import org.xtext.moduleDsl.boolConstant

class ChocoUtils {
	
	/**
	 * 
	 */
	def static Object chocoIntegerExpression(EXPRESSION exp, ProblemChoco pb, List<IntegerVariable> list){
 		switch(exp){
 			OR: pb.plus(exp.left.chocoIntegerExpression(pb,list), exp.right.chocoIntegerExpression(pb,list))
 			AND: pb.mult(exp.left.chocoIntegerExpression(pb,list), exp.right.chocoIntegerExpression(pb,list))
 			NOT: pb.minus(1, exp.exp.chocoIntegerExpression(pb,list))
 			COMPARISON:getIntegerVar(list, arithRepr(exp.left) + exp.op + arithRepr(exp.right))
 			EQUAL_DIFF: getIntegerVar(list, arithRepr(exp.left) + exp.op + arithRepr(exp.right))
 			VarExpRef: getIntegerVar(list, exp.vref.name)
 			boolConstant:getBooleanConstantVar(exp, pb)
 			//default:
 		}
	 }

	/**
	 * 
	 */
	 def static Object getBooleanConstantVar(boolConstant exp, ProblemChoco pb){
	 	val boolValue = exp.value
	 	if(boolValue){
	 		return pb.makeIntConst(1)
	 	}
	 	else{
	 		return pb.makeIntConst(0)
	 	}
	 }
	
	/**
	 * 
	 */
	def static private Object getIntegerVar(List<IntegerVariable> list, String str){
	 	val listWithoutFirst = list.subList(1, list.size)
	 	for(e: listWithoutFirst){
	 		if(e.name.normalizedName == str){
	 			return e
	 		}
	 	}
	 	throw new Exception("Error choco")
	 }
}
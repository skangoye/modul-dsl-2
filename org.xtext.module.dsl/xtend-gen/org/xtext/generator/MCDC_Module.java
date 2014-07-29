package org.xtext.generator;

import com.google.common.base.Objects;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.xtext.generator.MCDC_GeneratorUtils;
import org.xtext.generator.MCDC_Statement;
import org.xtext.helper.Triplet;
import org.xtext.moduleDsl.ASSIGN_STATEMENT;
import org.xtext.moduleDsl.AbstractVAR_DECL;
import org.xtext.moduleDsl.BODY;
import org.xtext.moduleDsl.ERROR_STATEMENT;
import org.xtext.moduleDsl.IF_STATEMENT;
import org.xtext.moduleDsl.LOOP_STATEMENT;
import org.xtext.moduleDsl.MODULE_DECL;
import org.xtext.moduleDsl.STATEMENT;
import org.xtext.optimization.optimStrategy1;

@SuppressWarnings("all")
public class MCDC_Module {
  private final MCDC_Statement mcdcStatement = new Function0<MCDC_Statement>() {
    public MCDC_Statement apply() {
      MCDC_Statement _mCDC_Statement = new MCDC_Statement();
      return _mCDC_Statement;
    }
  }.apply();
  
  private final optimStrategy1 optim = new Function0<optimStrategy1>() {
    public optimStrategy1 apply() {
      optimStrategy1 _optimStrategy1 = new optimStrategy1();
      return _optimStrategy1;
    }
  }.apply();
  
  public void enumerateAllModulePaths(final MODULE_DECL module) {
    BODY _body = module.getBody();
    final EList<STATEMENT> allStatements = _body.getStatements();
    ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> _arrayList = new ArrayList<List<Triplet<List<String>,List<String>,List<String>>>>();
    List<List<Triplet<List<String>,List<String>,List<String>>>> result = _arrayList;
    for (final STATEMENT st : allStatements) {
      boolean _matched = false;
      if (!_matched) {
        if (st instanceof AbstractVAR_DECL) {
          final AbstractVAR_DECL _abstractVAR_DECL = (AbstractVAR_DECL)st;
          _matched=true;
          final Triplet<List<String>,List<String>,List<String>> triplet = this.mcdcStatement.mcdcVarStatement(_abstractVAR_DECL);
          boolean _notEquals = (!Objects.equal(triplet, null));
          if (_notEquals) {
            List<List<Triplet<List<String>,List<String>,List<String>>>> _tripletToListOfList = this.tripletToListOfList(triplet);
            List<List<Triplet<List<String>,List<String>,List<String>>>> _mergePaths = this.mergePaths(result, _tripletToListOfList);
            result = _mergePaths;
          }
        }
      }
      if (!_matched) {
        if (st instanceof ASSIGN_STATEMENT) {
          final ASSIGN_STATEMENT _aSSIGN_STATEMENT = (ASSIGN_STATEMENT)st;
          _matched=true;
          final Triplet<List<String>,List<String>,List<String>> triplet = this.mcdcStatement.mcdcAssignStatement(_aSSIGN_STATEMENT);
          boolean _notEquals = (!Objects.equal(triplet, null));
          if (_notEquals) {
            List<List<Triplet<List<String>,List<String>,List<String>>>> _tripletToListOfList = this.tripletToListOfList(triplet);
            List<List<Triplet<List<String>,List<String>,List<String>>>> _mergePaths = this.mergePaths(result, _tripletToListOfList);
            result = _mergePaths;
          }
        }
      }
      if (!_matched) {
        if (st instanceof IF_STATEMENT) {
          final IF_STATEMENT _iF_STATEMENT = (IF_STATEMENT)st;
          _matched=true;
          ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> _mcdcIfStatement = this.mcdcStatement.mcdcIfStatement(_iF_STATEMENT);
          List<List<Triplet<List<String>,List<String>,List<String>>>> _mergePaths = this.mergePaths(result, _mcdcIfStatement);
          result = _mergePaths;
        }
      }
      if (!_matched) {
        if (st instanceof ERROR_STATEMENT) {
          final ERROR_STATEMENT _eRROR_STATEMENT = (ERROR_STATEMENT)st;
          _matched=true;
        }
      }
      if (!_matched) {
        if (st instanceof LOOP_STATEMENT) {
          final LOOP_STATEMENT _lOOP_STATEMENT = (LOOP_STATEMENT)st;
          _matched=true;
        }
      }
    }
    int _size = result.size();
    String _plus = ("Size is: " + Integer.valueOf(_size));
    System.out.println(_plus);
    final ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> result2 = MCDC_GeneratorUtils.copyListOfList(result);
    MCDC_GeneratorUtils.assignVariableIdentifier(result2);
    System.out.println("####### MODULES PATHS #######");
    for (final List<Triplet<List<String>,List<String>,List<String>>> r : result2) {
      {
        System.out.println("{");
        for (final Triplet<List<String>,List<String>,List<String>> rr : r) {
          {
            List<String> _first = rr.getFirst();
            String _string = _first.toString();
            String _plus_1 = (_string + " => ");
            System.out.print(_plus_1);
            List<String> _second = rr.getSecond();
            String _string_1 = _second.toString();
            String _plus_2 = (_string_1 + " => ");
            System.out.print(_plus_2);
            List<String> _third = rr.getThird();
            String _string_2 = _third.toString();
            System.out.println(_string_2);
          }
        }
        System.out.println("}");
        System.out.println();
      }
    }
    System.out.println();
    System.out.println("####### TEST SUITES #######");
    final ArrayList<Triplet<List<String>,List<String>,List<String>>> concatResult = this.mcdcStatement.concatMcdcValues2(result2);
    for (final Triplet<List<String>,List<String>,List<String>> cr : concatResult) {
      {
        List<String> _first = cr.getFirst();
        String _string = _first.toString();
        String _plus_1 = (_string + " => ");
        System.out.print(_plus_1);
        List<String> _second = cr.getSecond();
        String _string_1 = _second.toString();
        String _plus_2 = (_string_1 + " => ");
        System.out.print(_plus_2);
        List<String> _third = cr.getThird();
        String _string_2 = _third.toString();
        System.out.println(_string_2);
        System.out.println();
      }
    }
    System.out.println();
    System.out.println("####### COVERAGE RESULT #######");
    final ArrayList<Triplet<List<String>,Set<String>,List<String>>> splitResult = this.mcdcStatement.splitConcatenatedValues(concatResult);
    for (final Triplet<List<String>,Set<String>,List<String>> sr : splitResult) {
      {
        List<String> _first = sr.getFirst();
        String _string = _first.toString();
        String _plus_1 = (_string + " => ");
        System.out.print(_plus_1);
        Set<String> _second = sr.getSecond();
        String _string_1 = _second.toString();
        String _plus_2 = (_string_1 + " => ");
        System.out.print(_plus_2);
        List<String> _third = sr.getThird();
        String _string_2 = _third.toString();
        System.out.println(_string_2);
        System.out.println();
      }
    }
    final ArrayList<Triplet<List<String>,List<String>,List<String>>> notCoveredValues = this.mcdcStatement.notCoveredValues(splitResult);
    System.out.println();
    System.out.println("####### NOT COVERED ####### ");
    for (final Triplet<List<String>,List<String>,List<String>> nc : notCoveredValues) {
      {
        List<String> _first = nc.getFirst();
        String _string = _first.toString();
        String _plus_1 = (_string + " => ");
        System.out.print(_plus_1);
        List<String> _second = nc.getSecond();
        String _string_1 = _second.toString();
        String _plus_2 = (_string_1 + " => ");
        System.out.print(_plus_2);
        List<String> _third = nc.getThird();
        String _string_2 = _third.toString();
        System.out.println(_string_2);
        System.out.println();
      }
    }
    final ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> listOfEquations = this.mcdcStatement.buildEquations(notCoveredValues, result2);
    System.out.println();
    System.out.println("####### EQUATIONS ####### ");
    for (final List<Triplet<List<String>,List<String>,List<String>>> eq : listOfEquations) {
      {
        System.out.println("{");
        for (final Triplet<List<String>,List<String>,List<String>> rr : eq) {
          {
            List<String> _first = rr.getFirst();
            String _string = _first.toString();
            String _plus_1 = (_string + " => ");
            System.out.print(_plus_1);
            List<String> _second = rr.getSecond();
            String _string_1 = _second.toString();
            String _plus_2 = (_string_1 + " => ");
            System.out.print(_plus_2);
            List<String> _third = rr.getThird();
            String _string_2 = _third.toString();
            System.out.println(_string_2);
          }
        }
        System.out.println("}");
        System.out.println();
      }
    }
    System.out.println("####### Solving... #######");
    for (final List<Triplet<List<String>,List<String>,List<String>>> equations : listOfEquations) {
      this.mcdcStatement.translateAndSolveEquationsWithChoco(equations, concatResult);
    }
    System.out.println("####### NEW TEST SUITES... #######");
    System.out.println();
    for (final Triplet<List<String>,List<String>,List<String>> cr_1 : concatResult) {
      List<String> _second = cr_1.getSecond();
      int _size_1 = _second.size();
      boolean _greaterThan = (_size_1 > 0);
      if (_greaterThan) {
        List<String> _first = cr_1.getFirst();
        String _string = _first.toString();
        String _plus_1 = (_string + " => ");
        System.out.print(_plus_1);
        List<String> _second_1 = cr_1.getSecond();
        String _string_1 = _second_1.toString();
        String _plus_2 = (_string_1 + " => ");
        System.out.print(_plus_2);
        List<String> _third = cr_1.getThird();
        String _string_2 = _third.toString();
        System.out.println(_string_2);
        System.out.println();
      }
    }
    System.out.println();
    System.out.println();
    System.out.println("####### COVERAGE RESULT #######");
    final ArrayList<Triplet<List<String>,Set<String>,List<String>>> splitResult1 = this.mcdcStatement.splitConcatenatedValues(concatResult);
    for (final Triplet<List<String>,Set<String>,List<String>> sr_1 : splitResult1) {
      {
        List<String> _first_1 = sr_1.getFirst();
        String _string_3 = _first_1.toString();
        String _plus_3 = (_string_3 + " => ");
        System.out.print(_plus_3);
        Set<String> _second_2 = sr_1.getSecond();
        String _string_4 = _second_2.toString();
        String _plus_4 = (_string_4 + " => ");
        System.out.print(_plus_4);
        List<String> _third_1 = sr_1.getThird();
        String _string_5 = _third_1.toString();
        System.out.println(_string_5);
        System.out.println();
      }
    }
    final ArrayList<Triplet<List<String>,List<String>,List<String>>> notCoveredValues2 = this.mcdcStatement.notCoveredValues(splitResult1);
    System.out.println();
    System.out.println("####### NOT COVERED ####### ");
    for (final Triplet<List<String>,List<String>,List<String>> nc_1 : notCoveredValues2) {
      {
        List<String> _first_1 = nc_1.getFirst();
        String _string_3 = _first_1.toString();
        String _plus_3 = (_string_3 + " => ");
        System.out.print(_plus_3);
        List<String> _second_2 = nc_1.getSecond();
        String _string_4 = _second_2.toString();
        String _plus_4 = (_string_4 + " => ");
        System.out.print(_plus_4);
        List<String> _third_1 = nc_1.getThird();
        String _string_5 = _third_1.toString();
        System.out.println(_string_5);
        System.out.println();
      }
    }
    System.out.println();
    System.out.println("####### VECTORS ####### ");
    ArrayList<List<String>> _mcdcvalues = this.mcdcStatement.mcdcvalues();
    this.optim.optimize(concatResult, _mcdcvalues, notCoveredValues2);
  }
  
  private List<List<Triplet<List<String>,List<String>,List<String>>>> tripletToListOfList(final Triplet<List<String>,List<String>,List<String>> triplet) {
    ArrayList<Triplet<List<String>,List<String>,List<String>>> _arrayList = new ArrayList<Triplet<List<String>,List<String>,List<String>>>();
    final ArrayList<Triplet<List<String>,List<String>,List<String>>> tmp = _arrayList;
    tmp.add(triplet);
    ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> _arrayList_1 = new ArrayList<List<Triplet<List<String>,List<String>,List<String>>>>();
    final List<List<Triplet<List<String>,List<String>,List<String>>>> tmpList = _arrayList_1;
    tmpList.add(tmp);
    return tmpList;
  }
  
  private List<List<Triplet<List<String>,List<String>,List<String>>>> mergePaths(final List<List<Triplet<List<String>,List<String>,List<String>>>> list1, final List<List<Triplet<List<String>,List<String>,List<String>>>> list2) {
    try {
      ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> _arrayList = new ArrayList<List<Triplet<List<String>,List<String>,List<String>>>>();
      final ArrayList<List<Triplet<List<String>,List<String>,List<String>>>> result = _arrayList;
      final int size1 = list1.size();
      final int size2 = list2.size();
      boolean _equals = (size2 == 0);
      if (_equals) {
        Exception _exception = new Exception("Invalid argument");
        throw _exception;
      } else {
        boolean _equals_1 = (size1 == 0);
        if (_equals_1) {
          return list2;
        } else {
          for (final List<Triplet<List<String>,List<String>,List<String>>> e1 : list1) {
            for (final List<Triplet<List<String>,List<String>,List<String>>> e2 : list2) {
              {
                ArrayList<Triplet<List<String>,List<String>,List<String>>> _arrayList_1 = new ArrayList<Triplet<List<String>,List<String>,List<String>>>();
                final ArrayList<Triplet<List<String>,List<String>,List<String>>> tmpList = _arrayList_1;
                tmpList.addAll(e1);
                tmpList.addAll(e2);
                result.add(tmpList);
              }
            }
          }
        }
      }
      return result;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

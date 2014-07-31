package org.xtext.generator;

import com.google.common.base.Objects;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.xtext.generator.MCDC_GeneratorUtils;
import org.xtext.generator.MCDC_Statement;
import org.xtext.helper.Couple;
import org.xtext.helper.Triplet;
import org.xtext.moduleDsl.ASSIGN_STATEMENT;
import org.xtext.moduleDsl.AbstractVAR_DECL;
import org.xtext.moduleDsl.BODY;
import org.xtext.moduleDsl.ERROR_STATEMENT;
import org.xtext.moduleDsl.EXPRESSION;
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
    this.staticSingleAssignment(result2);
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
  
  public void staticSingleAssignment(final List<List<Triplet<List<String>,List<String>,List<String>>>> listOfList) {
    for (final List<Triplet<List<String>,List<String>,List<String>>> list : listOfList) {
      {
        ArrayList<Couple<String,Integer>> _arrayList = new ArrayList<Couple<String,Integer>>();
        final ArrayList<Couple<String,Integer>> defList = _arrayList;
        for (final Triplet<List<String>,List<String>,List<String>> triplet : list) {
          {
            ArrayList<Couple<String,Integer>> _arrayList_1 = new ArrayList<Couple<String,Integer>>();
            final ArrayList<Couple<String,Integer>> useList = _arrayList_1;
            List<String> _third = triplet.getThird();
            final String identifier = MCDC_GeneratorUtils.extractIdentifier(_third);
            List<String> _third_1 = triplet.getThird();
            final String identifierIndex = MCDC_GeneratorUtils.extractIdentIndex(_third_1);
            boolean _equals = Objects.equal(identifierIndex, "N");
            if (_equals) {
              int _parseInt = MCDC_GeneratorUtils.parseInt(identifier);
              final List<String> varInExpression = this.mcdcStatement.listOfVarInNonBoolExpression.get(_parseInt);
              this.initUseList(useList, varInExpression);
              this.updateUseList(useList, defList);
              int _size = useList.size();
              boolean _notEquals = (_size != 0);
              if (_notEquals) {
                int _parseInt_1 = MCDC_GeneratorUtils.parseInt(identifier);
                final EXPRESSION expression = this.mcdcStatement.listOfNonBooleanExpression.get(_parseInt_1);
                ArrayList<String> _arrayList_2 = new ArrayList<String>();
                final ArrayList<String> renamedList = _arrayList_2;
                MCDC_GeneratorUtils.renameVarInBoolExpression(expression, useList, renamedList);
                System.out.println();
                String _string = renamedList.toString();
                String _plus = ("Renamed list: " + _string);
                System.out.println(_plus);
                System.out.println();
                triplet.setSecond(renamedList);
              }
              List<String> _first = triplet.getFirst();
              final String assignVar = _first.get(0);
              boolean _notEquals_1 = (!Objects.equal(assignVar, "*"));
              if (_notEquals_1) {
                final Couple<String,Integer> defCouple = this.updateDefList(defList, assignVar);
                List<String> _first_1 = triplet.getFirst();
                String _first_2 = defCouple.getFirst();
                Integer _second = defCouple.getSecond();
                String _plus_1 = (_first_2 + _second);
                _first_1.set(0, _plus_1);
              }
            } else {
              int _parseInt_2 = MCDC_GeneratorUtils.parseInt(identifier);
              final List<String> varInExpression_1 = this.mcdcStatement.listOfVarInBoolExpression.get(_parseInt_2);
              this.initUseList(useList, varInExpression_1);
              this.updateUseList(useList, defList);
              int _size_1 = useList.size();
              boolean _notEquals_2 = (_size_1 != 0);
              if (_notEquals_2) {
                int _parseInt_3 = MCDC_GeneratorUtils.parseInt(identifier);
                final EXPRESSION expression_1 = this.mcdcStatement.listOfBooleanExpression.get(_parseInt_3);
                ArrayList<String> _arrayList_3 = new ArrayList<String>();
                final ArrayList<String> renamedList_1 = _arrayList_3;
                MCDC_GeneratorUtils.renameVarInBoolExpression(expression_1, useList, renamedList_1);
                System.out.println();
                String _string_1 = renamedList_1.toString();
                String _plus_2 = ("Renamed list: " + _string_1);
                System.out.println(_plus_2);
                System.out.println();
                triplet.setFirst(renamedList_1);
              }
              List<String> _first_3 = triplet.getFirst();
              final String assignVar_1 = _first_3.get(0);
              boolean _notEquals_3 = (!Objects.equal(assignVar_1, "*"));
              if (_notEquals_3) {
                final Couple<String,Integer> defCouple_1 = this.updateDefList(defList, assignVar_1);
                List<String> _first_4 = triplet.getFirst();
                String _first_5 = defCouple_1.getFirst();
                Integer _second_1 = defCouple_1.getSecond();
                String _plus_3 = (_first_5 + _second_1);
                _first_4.set(0, _plus_3);
              }
            }
          }
        }
      }
    }
  }
  
  public void initUseList(final List<Couple<String,Integer>> useList, final List<String> list) {
    final Procedure1<String> _function = new Procedure1<String>() {
        public void apply(final String elem) {
          int _minus = (-1);
          Couple<String,Integer> _couple = new Couple<String,Integer>(elem, Integer.valueOf(_minus));
          useList.add(_couple);
        }
      };
    IterableExtensions.<String>forEach(list, _function);
  }
  
  public void updateUseList(final List<Couple<String,Integer>> useList, final List<Couple<String,Integer>> previousDefList) {
    final Procedure1<Couple<String,Integer>> _function = new Procedure1<Couple<String,Integer>>() {
        public void apply(final Couple<String,Integer> use) {
          final Procedure1<Couple<String,Integer>> _function = new Procedure1<Couple<String,Integer>>() {
              public void apply(final Couple<String,Integer> previousDef) {
                String _first = use.getFirst();
                String _first_1 = previousDef.getFirst();
                boolean _equals = Objects.equal(_first, _first_1);
                if (_equals) {
                  Integer _second = previousDef.getSecond();
                  use.setSecond(_second);
                }
              }
            };
          IterableExtensions.<Couple<String,Integer>>forEach(previousDefList, _function);
        }
      };
    IterableExtensions.<Couple<String,Integer>>forEach(useList, _function);
  }
  
  public Couple<String,Integer> updateDefList(final List<Couple<String,Integer>> defList, final String assignVar) {
    for (final Couple<String,Integer> defCouple : defList) {
      String _first = defCouple.getFirst();
      boolean _equals = Objects.equal(_first, assignVar);
      if (_equals) {
        final Integer value = defCouple.getSecond();
        int _intValue = value.intValue();
        int _plus = (_intValue + 1);
        defCouple.setSecond(Integer.valueOf(_plus));
        return defCouple;
      }
    }
    Couple<String,Integer> _couple = new Couple<String,Integer>(assignVar, Integer.valueOf(0));
    final Couple<String,Integer> newCouple = _couple;
    defList.add(newCouple);
    return newCouple;
  }
}

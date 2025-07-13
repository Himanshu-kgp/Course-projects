function [Q_FE] = FE(v_f, E_f, nu_f, E_m, nu_m)
%
% FE.m
%
% Model exported on Apr 8 2025, 16:55 by COMSOL 6.2.0.290.
% Author: COMSOL

import com.comsol.model.*
import com.comsol.model.util.*
ModelUtil.showProgress(true);

model = ModelUtil.create('Model');

model.modelPath('C:\Users\17ME91R03\Desktop\Mechanics of Composites Term Project\comsol\micromechanical_model_of_a_fiber_composite');

model.label('model.mph');

model.title('Micromechanical Model of a Fiber Composite');

model.description('In this example, a simplified micromechanical model of a fiber composite''s unit cell is analyzed. The homogenized elastic and thermal properties of a composite material are computed based on the individual properties of fiber and matrix. A comparison is made against values obtained from the rule of mixture.');

model.baseSystem('SI');

model.param.set('l_x', '0.2[m]', 'Unit cell length');
model.param.set('l_y', '0.1 [m]');
model.param.set('l_z', '0.1 [m]');
model.param.set('V', 'l_x*l_y*l_z', 'Unit cell volume');
model.param.set('v_f', v_f, 'Fiber volume fraction');
model.param.set('v_m', '1-v_f', 'Resin volume of fraction');
model.param.set('V_f', 'v_f*V', 'Fiber volume');
model.param.set('r_f', 'sqrt(V_f/(pi*l_x))', 'Fiber radius');
model.param.set('E_f', strcat(num2str(E_f), " [Pa]"), 'Fiber Young''s modulus, 11 direction');
model.param.set('nu_f', nu_f, 'Fiber Poisson''s ratio, 12 direction');
model.param.set('E_m', strcat(num2str(E_m), " [Pa]"), 'Resin Young''s modulus');
model.param.set('nu_m', nu_m, 'Resin Poisson''s ratio');
model.param.set('G_m', 'E_m/(2*(1+nu_m))', 'Resin shear modulus');
model.param.set('rho_f', '1800[kg/m^3]', 'Fiber density');
model.param.set('rho_m', '1100[kg/m^3]', 'Resin density');
model.param.set('h_max', '0.025 [m]');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.result.evaluationGroup.create('solidcp1stdEg', 'EvaluationGroup');
model.result.evaluationGroup('solidcp1stdEg').create('gmevcp1', 'EvalGlobalMatrix');

model.component('comp1').mesh.create('mesh1');

model.geom.load({'part1'}, 'COMSOL_Multiphysics/Unit_Cells_and_RVEs/Fiber_Composites/unidirectional_fiber_square_packing.mph', {'part1'});
model.component('comp1').geom('geom1').geomRep('comsol');
model.component('comp1').geom('geom1').create('pi1', 'PartInstance');
model.component('comp1').geom('geom1').feature('pi1').setEntry('inputexpr', 'df', '2*r_f');
model.component('comp1').geom('geom1').feature('pi1').setEntry('inputexpr', 'wm', 'l_x');
model.component('comp1').geom('geom1').feature('pi1').setEntry('inputexpr', 'dm', 'l_y');
model.component('comp1').geom('geom1').feature('pi1').setEntry('inputexpr', 'hm', 'l_z');
model.component('comp1').geom('geom1').feature('pi1').setEntry('inputexpr', 'internal_voids', '0');
model.component('comp1').geom('geom1').feature('pi1').set('selkeepnoncontr', false);
model.component('comp1').geom('geom1').run('pi1');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').material.create('matlnk1', 'Link');
model.material.create('mat1', 'Common', '');
model.component('comp1').material.create('matlnk2', 'Link');
model.material.create('mat2', 'Common', '');
model.component('comp1').material('matlnk1').selection.named('geom1_pi1_dif1_dom');
model.material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('matlnk2').selection.named('geom1_pi1_cyl1_dom');
model.material('mat2').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');

model.group.create('cp11', 'LoadGroup');
model.group.create('cp22', 'LoadGroup');
model.group.create('cp33', 'LoadGroup');
model.group.create('cp12', 'LoadGroup');
model.group.create('cp23', 'LoadGroup');
model.group.create('cp13', 'LoadGroup');

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').create('cp1', 'CellPeriodicity', 3);
model.component('comp1').physics('solid').feature('cp1').create('bp1', 'BoundaryPair', 2);
model.component('comp1').physics('solid').feature('cp1').feature('bp1').selection.set([1 5 11 12]);
model.component('comp1').physics('solid').feature('cp1').create('bp2', 'BoundaryPair', 2);
model.component('comp1').physics('solid').feature('cp1').feature('bp2').selection.set([2 10]);
model.component('comp1').physics('solid').feature('cp1').create('bp3', 'BoundaryPair', 2);
model.component('comp1').physics('solid').feature('cp1').feature('bp3').selection.set([3 4]);

model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').create('swe1', 'Sweep');
model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([1 5]);

model.component('comp1').view('view1').set('showgrid', false);

model.component('comp1').material('matlnk1').label('Material Link 1: Epoxy Resin');
model.component('comp1').material('matlnk1').set('link', 'mat1');
model.material('mat1').label('Material 1: Epoxy Resin');
model.material('mat1').propertyGroup('def').set('density', 'rho_m');
model.material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', {'alpha_m' '0' '0' '0' 'alpha_m' '0' '0' '0' 'alpha_m'});
model.material('mat1').propertyGroup('Enu').set('E', 'E_m');
model.material('mat1').propertyGroup('Enu').set('nu', 'nu_m');
model.component('comp1').material('matlnk2').label('Material Link 2: Carbon Fiber');
model.component('comp1').material('matlnk2').set('link', 'mat2');
model.material('mat2').label('Material 2: Glass Fiber');
model.material('mat2').propertyGroup('def').set('density', 'rho_f');
model.material('mat2').propertyGroup('def').set('thermalexpansioncoefficient', {'alpha1_f' '0' '0' '0' 'alpha2_f' '0' '0' '0' 'alpha2_f'});
model.material('mat2').propertyGroup('Enu').set('E', 'E_f');
model.material('mat2').propertyGroup('Enu').set('nu', 'nu_f');

model.component('comp1').physics('solid').feature('lemm1').set('SolidModel', 'Orthotropic');
model.component('comp1').physics('solid').feature('cp1').set('BoundaryExpansion', 'PrescribedStrain');
model.component('comp1').physics('solid').feature('cp1').set('EffectivePropertiese', 'ElasticityMatrixVoigt');
model.component('comp1').physics('solid').feature('cp1').set('eavgi', {'group.cp11' '0.5*group.cp12' '0.5*group.cp13' '0.5*group.cp12' 'group.cp22' '0.5*group.cp23' '0.5*group.cp13' '0.5*group.cp23' 'group.cp33'});
model.component('comp1').physics('solid').feature('cp1').set('parameterName', 'v_f');
model.component('comp1').physics('solid').feature('cp1').set('parameterRange', 'range(0.1,0.1,0.7)');
model.component('comp1').physics('solid').feature('cp1').label('Cell Periodicity for Elastic Properties');

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 2);
model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 'h_max');
model.component('comp1').mesh('mesh1').run;

model.study.create('solidcp1std');
model.study('solidcp1std').create('solidcp1stat', 'Stationary');

model.sol.create('solidcp1sol');
model.sol('solidcp1sol').study('solidcp1std');
model.sol('solidcp1sol').attach('solidcp1std');
model.sol('solidcp1sol').create('st1', 'StudyStep');
model.sol('solidcp1sol').create('v1', 'Variables');
model.sol('solidcp1sol').create('s1', 'Stationary');
model.sol('solidcp1sol').feature('s1').create('p1', 'Parametric');
model.sol('solidcp1sol').feature('s1').create('fc1', 'FullyCoupled');
model.sol('solidcp1sol').feature('s1').create('d1', 'Direct');
model.sol('solidcp1sol').feature('s1').create('i1', 'Iterative');
model.sol('solidcp1sol').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('pr').create('so1', 'SOR');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('po').create('so1', 'SOR');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('solidcp1sol').feature('s1').feature.remove('fcDef');
model.sol.create('solidcp1solp');
model.sol('solidcp1solp').study('solidcp1std');

model.batch.create('solidcp1p', 'Parametric');
model.batch('solidcp1p').create('solidcp1sop', 'Solutionseq');
model.batch('solidcp1p').study('solidcp1std');

model.result.create('pg6', 'PlotGroup3D');
model.result.create('pg1', 'PlotGroup3D');
model.result.create('pg3', 'PlotGroup1D');
model.result.create('pg4', 'PlotGroup1D');
model.result.create('pg5', 'PlotGroup1D');
model.result('pg6').set('data', 'dset2');
model.result('pg6').create('vol1', 'Volume');
model.result('pg6').create('vol2', 'Volume');
model.result('pg6').feature('vol1').set('expr', '1');
model.result('pg6').feature('vol1').create('sel1', 'Selection');
model.result('pg6').feature('vol1').create('def1', 'Deform');
model.result('pg6').feature('vol1').feature('sel1').selection.set([1]);
model.result('pg6').feature('vol2').set('expr', '1');
model.result('pg6').feature('vol2').create('sel1', 'Selection');
model.result('pg6').feature('vol2').create('def1', 'Deform');
model.result('pg6').feature('vol2').feature('sel1').selection.set([2]);
model.result('pg1').set('data', 'dset2');
model.result('pg1').create('mesh1', 'Mesh');
model.result('pg1').feature('mesh1').create('def1', 'Deform');
model.result('pg3').set('data', 'dset2');
model.result('pg3').create('glob1', 'Global');
model.result('pg4').set('data', 'dset2');
model.result('pg4').create('glob1', 'Global');
model.result('pg5').set('data', 'dset2');
model.result('pg5').create('glob1', 'Global');

model.nodeGroup.create('cpgrp', 'GlobalDefinitions');
model.nodeGroup('cpgrp').set('type', 'group');
model.nodeGroup('cpgrp').placeAfter([]);
model.nodeGroup.create('grp1', 'Results');
model.nodeGroup('grp1').set('type', 'plotgroup');
model.nodeGroup('grp1').placeAfter('plotgroup', 'pg1');

model.study('solidcp1std').label('Cell Periodicity Study for Elastic Properties');
model.study('solidcp1std').feature('solidcp1stat').set('plot', true);
model.study('solidcp1std').feature('solidcp1stat').set('plotgroup', 'pg1');
model.study('solidcp1std').feature('solidcp1stat').set('useloadcase', true);
model.study('solidcp1std').feature('solidcp1stat').set('loadcase', {'Load case 1' 'Load case 2' 'Load case 3' 'Load case 4' 'Load case 5' 'Load case 6'});
model.study('solidcp1std').feature('solidcp1stat').set('loadgroup', {'on' 'off' 'off' 'off' 'off' 'off';  ...
'off' 'on' 'off' 'off' 'off' 'off';  ...
'off' 'off' 'on' 'off' 'off' 'off';  ...
'off' 'off' 'off' 'on' 'off' 'off';  ...
'off' 'off' 'off' 'off' 'on' 'off';  ...
'off' 'off' 'off' 'off' 'off' 'on'});
model.study('solidcp1std').feature('solidcp1stat').set('loadgroupweight', {'1.0' '1.0' '1.0' '1.0' '1.0' '1.0';  ...
'1.0' '1.0' '1.0' '1.0' '1.0' '1.0';  ...
'1.0' '1.0' '1.0' '1.0' '1.0' '1.0';  ...
'1.0' '1.0' '1.0' '1.0' '1.0' '1.0';  ...
'1.0' '1.0' '1.0' '1.0' '1.0' '1.0';  ...
'1.0' '1.0' '1.0' '1.0' '1.0' '1.0'});
model.study('solidcp1std').feature('solidcp1stat').set('constraintgroup', javaArray('java.lang.String', 6, 0));

model.sol('solidcp1sol').attach('solidcp1std');
model.sol('solidcp1sol').feature('st1').label('Compile Equations: Stationary');
model.sol('solidcp1sol').feature('v1').label('Dependent Variables 1.1');
model.sol('solidcp1sol').feature('s1').label('Stationary Solver 1.1');
model.sol('solidcp1sol').feature('s1').set('probesel', 'none');
model.sol('solidcp1sol').feature('s1').feature('dDef').label('Direct 2');
model.sol('solidcp1sol').feature('s1').feature('aDef').label('Advanced 1');
model.sol('solidcp1sol').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('solidcp1sol').feature('s1').feature('p1').label('Parametric 1.1');
model.sol('solidcp1sol').feature('s1').feature('p1').set('plooporder', 'manual');
model.sol('solidcp1sol').feature('s1').feature('p1').set('useloadcase', true);
model.sol('solidcp1sol').feature('s1').feature('p1').set('loadgroup', {'on' 'off' 'off' 'off' 'off' 'off';  ...
'off' 'on' 'off' 'off' 'off' 'off';  ...
'off' 'off' 'on' 'off' 'off' 'off';  ...
'off' 'off' 'off' 'on' 'off' 'off';  ...
'off' 'off' 'off' 'off' 'on' 'off';  ...
'off' 'off' 'off' 'off' 'off' 'on'});
model.sol('solidcp1sol').feature('s1').feature('p1').set('uselsqdata', false);
model.sol('solidcp1sol').feature('s1').feature('p1').set('plot', true);
model.sol('solidcp1sol').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('solidcp1sol').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('solidcp1sol').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('solidcp1sol').feature('s1').feature('d1').label('Suggested Direct Solver (solid)');
model.sol('solidcp1sol').feature('s1').feature('i1').label('Suggested Iterative Solver (solid)');
model.sol('solidcp1sol').feature('s1').feature('i1').set('linsolver', 'fgmres');
model.sol('solidcp1sol').feature('s1').feature('i1').set('nlinnormuse', true);
model.sol('solidcp1sol').feature('s1').feature('i1').feature('ilDef').label('Incomplete LU 1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').label('Multigrid 1.1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('pr').label('Presmoother 1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('pr').feature('soDef').label('SOR 2');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('pr').feature('so1').label('SOR 1.1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('pr').feature('so1').set('relax', 0.8);
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('po').label('Postsmoother 1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('po').feature('soDef').label('SOR 2');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('po').feature('so1').label('SOR 1.1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('po').feature('so1').set('relax', 0.8);
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('cs').label('Coarse Solver 1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('cs').feature('dDef').label('Direct 2');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').label('Direct 1.1');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('solidcp1sol').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-9);
model.sol('solidcp1sol').runAll;

model.batch('solidcp1p').set('sweeptype', 'filled');
model.batch('solidcp1p').set('pname', {'v_f' 'h_max'});
model.batch('solidcp1p').set('plistarr', {'range(0.1, 0.1, 0.5)' '0.025, 0.02, 0.016, 0.011, 0.007'});
model.batch('solidcp1p').set('punit', {'' 'm'});
model.batch('solidcp1p').set('err', true);
model.batch('solidcp1p').feature('solidcp1sop').set('seq', 'solidcp1sol');
model.batch('solidcp1p').feature('solidcp1sop').set('store', true);
model.batch('solidcp1p').feature('solidcp1sop').set('psol', 'solidcp1solp');
model.batch('solidcp1p').feature('solidcp1sop').set('keeprom', true);
model.batch('solidcp1p').feature('solidcp1sop').set('param', {'"v_f","0.1","h_max","0.025"' '"v_f","0.1","h_max","0.02"' '"v_f","0.1","h_max","0.016"' '"v_f","0.1","h_max","0.011"' '"v_f","0.1","h_max","0.007"' '"v_f","0.2","h_max","0.025"' '"v_f","0.2","h_max","0.02"' '"v_f","0.2","h_max","0.016"' '"v_f","0.2","h_max","0.011"' '"v_f","0.2","h_max","0.007"'  ...
'"v_f","0.3","h_max","0.025"' '"v_f","0.3","h_max","0.02"' '"v_f","0.3","h_max","0.016"' '"v_f","0.3","h_max","0.011"' '"v_f","0.3","h_max","0.007"' '"v_f","0.4","h_max","0.025"' '"v_f","0.4","h_max","0.02"' '"v_f","0.4","h_max","0.016"' '"v_f","0.4","h_max","0.011"' '"v_f","0.4","h_max","0.007"'  ...
'"v_f","0.5","h_max","0.025"' '"v_f","0.5","h_max","0.02"' '"v_f","0.5","h_max","0.016"' '"v_f","0.5","h_max","0.011"' '"v_f","0.5","h_max","0.007"'});
model.batch('solidcp1p').attach('solidcp1std');

model.component('comp1').geom('geom1').run;

model.result.dataset('dset2').set('solution', 'none');

model.sol.remove('solidcp1solp');

model.result('pg6').run;
model.result('pg6').set('data', 'none');
model.result.dataset.remove('dset2');

model.nodeGroup.remove('grp1');

model.result.evaluationGroup('solidcp1stdEg').run;
model.result.evaluationGroup('solidcp1stdEg').feature('gmevcp1').set('expr', 'comp1.solid.cp1.D');
model.result.evaluationGroup('solidcp1stdEg').feature('gmevcp1').set('descr', 'Elasticity matrix');
model.result.evaluationGroup('solidcp1stdEg').run;
model.result.evaluationGroup('solidcp1stdEg').run;
model.result.evaluationGroup('solidcp1stdEg').set('data', 'dset1');
model.result.evaluationGroup('solidcp1stdEg').run;
model.result.evaluationGroup('solidcp1stdEg').setIndex('looplevelinput', 'first', 0);
model.result.evaluationGroup('solidcp1stdEg').run;
model.result.numerical.create('gmev1', 'EvalGlobalMatrix');
model.result.numerical('gmev1').set('expr', 'root.comp1.solid.cp1.D');
model.result.table.create('tbl1', 'Table');
model.result.numerical('gmev1').set('table', 'tbl1');
model.result.numerical('gmev1').setResult;
model.result.table.remove('tbl1');
model.result.numerical.remove('gmev1');
model.result.evaluationGroup('solidcp1stdEg').set('includeparameters', false);
model.result.evaluationGroup('solidcp1stdEg').run;
model.result.numerical.create('gmev1', 'EvalGlobalMatrix');
model.result.numerical('gmev1').set('expr', 'root.comp1.solid.cp1.D');
model.result.table.create('tbl1', 'Table');
model.result.numerical('gmev1').set('table', 'tbl1');
model.result.numerical('gmev1').setResult;
model.result.table.remove('tbl1');
model.result.numerical.remove('gmev1');

Q_FE = mphevalglobalmatrix(model, "root.comp1.solid.cp1.D", "dataseries", "average");
Q_FE = [Q_FE(1, 1), Q_FE(1, 2), Q_FE(1, 4);
        Q_FE(2, 1), Q_FE(2, 2), Q_FE(1, 4);
        Q_FE(4, 1), Q_FE(4, 2), Q_FE(4, 4);];
end
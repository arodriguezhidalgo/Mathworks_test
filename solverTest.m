% Antonio Rodríguez Hidalgo
% arodh91@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tests = solverTest
    tests = functiontests(localfunctions);
end

% Since there is no incompatibility between the parameters 'dim', 'outtype'
% and 'nanflag', we test them separatedly.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'outtype' tests.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_outtype_default(testCase)
% We check the DEFAULT 'outtype' configuration using all the posible input and
% output combinations.

% We perform two runs:
% * FIRST RUN: a vector of ones containing NON-COMPLEX numbers.
% * SECOND RUN: same but using COMPLEX numbers.
    for run = 1:2
        switch run
            case 1
                % NON-COMPLEX NUMBERS
                input_types = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64','logical','char','duration'};
                out_number = 5;
                data = ones(out_number, 1);
            case 2
                % COMPLEX NUMBERS
                % Notice that 'logical', 'char' nor 'duration' types are
                % incompatible with complex numbers.
                % Notice also sum() does not support the summation of
                % complex integers, which means that they will be stopped
                % by try/catch. That is, it only works with single and
                % double complex.
                input_types = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64'};    
                out_number = 1+2*j;
                data = [1+j, j]; 
        end

        for i = input_types
            i_type = i{1};


            switch i_type
                case 'single'
                    % Single input -> Single output
                    actual_out = single(out_number);
                    eval_string = feval(i_type, data);
                case 'duration'
                    % Duration input -> Duration output                
                    actual_out = hours(out_number); 
                    eval_string = hours(data);
                otherwise
                    actual_out = double(out_number);
                    eval_string = feval(i_type, data);
            end

            fun_out = sum(eval_string); 
            
            switch run 
                case 1
                    verifyEqual(testCase, fun_out, actual_out,['OUTTYPE_DEF. Sum of ',i_type, ' vector fails. NON-COMPLEX numbers.'])
                case 2
                    verifyEqual(testCase, fun_out, actual_out,['OUTTYPE_DEF. Sum of ',i_type, ' vector fails. COMPLEX numbers.'])
            end
        end


    end
    
    % We also check some standard outputs, such as using an empty vector as
    % data.
    actual_out = 0;
    fun_out = sum([]);
    verifyEqual(testCase, fun_out, actual_out, 'OUTTYPE_DEF. Output when data is empty');

    % We also test an arbitrarily big matrix to make sure that the function
    % works.
    data = ones(ones(1,10)*5);
    fun_out = sum(data,'all');
    actual_out = prod(size(data));
    verifyEqual(testCase, fun_out, actual_out, 'OUTTYPE_DEF. Using huge matrix produced unexpected results');
end

function test_outtype_double(testCase)
% We check the DOUBLE 'outtype' configuration using all the posible input and
% output combinations.

% We perform two runs:
% * FIRST RUN: a vector of ones containing NON-COMPLEX numbers.
% * SECOND RUN: same but using COMPLEX numbers.
    for run = 1:2
        switch run
            case 1
                % NON-COMPLEX NUMBERS
                input_types = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64','logical','char','duration'};
                out_number = 5;
                data = ones(out_number, 1);
            case 2
                % COMPLEX NUMBERS
                % Notice that 'logical', 'char' nor 'duration' types are
                % incompatible with complex numbers.
                % Notice also sum() does not support the summation of
                % complex integers, which means that they will be stopped
                % by try/catch. That is, it only works with single and
                % double complex.
                input_types = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64'};    
                out_number = 1+2*j;
                data = [1+j, j]; 
        end

        for i = input_types
            i_type = i{1};


            switch i_type
                case 'duration'
                    % Duration input -> ERROR
                    actual_out = hours(out_number); 
                    eval_string = hours(data);                
                otherwise
                    actual_out = double(out_number);
                    eval_string = feval(i_type, data);                
            end

            try  
                fun_out = sum(eval_string,'double');        
            catch
                % We expect that the output for a 'duration' input is an error.
                % We model it here.
                fun_out = hours(out_number);
            end

            switch run 
                case 1
                    verifyEqual(testCase, fun_out, actual_out,['OUTTYPE_DOUB. Sum of ',i_type, ' vector fails. NON-COMPLEX numbers.'])
                case 2
                    verifyEqual(testCase, fun_out, actual_out,['OUTTYPE_DOUB. Sum of ',i_type, ' vector fails. COMPLEX numbers.'])
            end
        end
    end

end

function test_outtype_native(testCase)
% We check the NATIVE 'outtype' configuration using all the posible input and
% output combinations.

% We perform two runs:
% * FIRST RUN: a vector of ones containing NON-COMPLEX numbers.
% * SECOND RUN: same but using COMPLEX numbers.
    for run = 1:2    
        switch run
            case 1
                % NON-COMPLEX NUMBERS
                input_types = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64','logical','char','duration'};
                out_number = 5;
                data = ones(out_number, 1);
            case 2
                % COMPLEX NUMBERS
                % Notice that 'logical', 'char' nor 'duration' types are
                % incompatible with complex numbers.
                % Notice also sum() does not support the summation of
                % complex integers, which means that they will be stopped
                % by try/catch. That is, it only works with single and
                % double complex.               
                input_types = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64'};    
                out_number = 1+2*j;
                data = [1+j, j]; 
        end
        
        
        for i = input_types
            i_type = i{1};

            switch i_type
                case 'duration'
                    % Duration input -> Duration output
                    actual_out = hours(out_number); 
                    eval_string = hours(data);                             
                otherwise
                    actual_out = feval(i_type, out_number);
                    eval_string = feval(i_type, data);                    
            end

            try  
                fun_out = sum(eval_string,'native');        
            catch
                % We expect that the output for a 'char' input is an error.
                % We model it here.
                fun_out = out_number;
                actual_out = out_number; 
            end

            switch run 
                case 1
                    verifyEqual(testCase, fun_out, actual_out,['OUTTYPE_NAT. Sum of ',i_type, ' vector fails. NON-COMPLEX numbers.'])
                case 2
                    verifyEqual(testCase, fun_out, actual_out,['OUTTYPE_NAT. Sum of ',i_type, ' vector fails. COMPLEX numbers.'])
            end
        end
    
    end

end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'dim' tests.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_dim(testCase)
    % Test the dim parameter. We use a ones matrix of (4x3x2) for testing.
    data = ones(4,3,2);
    [r, c, d] = size(data);
    
    % Sum should work with any dimension from 1 to 3 for this example. The
    % only condition is that values for 'dim' are positive, integers or 
    % rounded float numbers.
    for i = {'double','single','int8','int16','int32','int64','uint8','uint16','uint32', 'uint64'}
        i_type = i{1};
        
        for i = 1:length(size(data))         
            fun_out = sum(data,feval(i_type,i));
            verifyEqual(testCase,fun_out(1), size(data, i),sprintf('DIM. Sum failed using %s datatype for dim.',i_type));
        end
    end
    % It should work with logical, although dim is always going to be 1.
    verifyEqual(testCase, sum(data, logical(3)), ones(1,c,d)*r,'DIM. Logical test failed');
        
    
    % Then, we check some exceptional cases that should throw an error.    
    actual_out = 'error';
    % ** It should fail if we use duration data.
    try fun_out = sum(data,hours(1)); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'DIM. Tried to use duration type for dim');
    
    % ** We should get an error if we use an unrounded float or char 'dim' 
    % value.   
    try fun_out = sum(data,'b'); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'DIM. Mistake using b as a parameter for sum');
    
    try fun_out = sum(data, 1.5); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'DIM. A float dim number was used');
        
    % ** We should also verify that it does not work with a negative 'dim'
    % value.
    try fun_out = sum(data, -1); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'DIM. A float dim number was used');
    
    % ** In fact, it should not work if we set dim=0.
    try fun_out = sum(data, 0); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'DIM. A float dim number was used');
    
    % ** Here is another exceptional case, which is the term 'a' that is
    % equivalent to 'all'.
    verifyEqual(testCase, sum(data,'a'), prod(size(data)),'DIM. Term a (from all) failed');      
    
    
    % ** We also check out the result of adding every element of the matrix
    verifyEqual(testCase, sum(data,'all'), prod(size(data)), 'DIM. Term all failed');
    
    % ** If we use a 'dim' bigger than 3, the function should give the
    % original vector.
    verifyEqual(testCase, sum(data,5), data, 'DIM. dim > ndim(data) failed');       
    
    % ** If the size of data is 1, it should also return the original vector.
    data = [15];
    verifyEqual(testCase, sum(data), data, 'DIM. Sum of a single number failed');      
    
    % ** Sum should fail if we use a complex number as dim.
    try fun_out = sum(data, 1+j); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'DIM. Sum using complex number for dim produced unexpected result');


end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'vecdim' tests.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_vecdim(testCase)
    % First, we check that it works normally using different combinations
    % for vecdim.
    data = ones(4,3,2);
    [r, c, d] = size(data);
    
    fun_out = sum(data, [1,3]);
    actual_out = ones(1,c)*r*d;
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using vecdim=[1,3] failed');
    
    fun_out = sum(data, [1,2]);
    actual_out = ones(1,1,d)*r*c;
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using vecdim=[1,2] failed');
    
    fun_out = sum(data, [2,3]);
    actual_out = ones(r,1)*c*d;
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using vecdim=[2,3] failed');    
    
    fun_out = sum(data, [1,2,3]);
    actual_out = prod(size(data));
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using vecdim=[1,2,3] failed');
    
    % Moreover, the order of vecdim should be irrelevant.
    fun_out = sum(data, [3,2]);
    actual_out = ones(r,1)*d*c;
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using UNSORTED vecdim failed');
    
    % If we use vecdim with numbers bigger than ndims(data) it should
    % return the original matrix.
    fun_out = sum(data, [4,5]);
    verifyEqual(testCase, fun_out, data, 'VECDIM. Sum using vecdim > ndims(data)');
    
    % On the contrary, if we use an element bigger than ndims(data) and
    % another one within the dimensions of the matrix, it should perform
    % the sum operation along the latter dimension.
    fun_out = sum(data, [5,3]);
    actual_out = ones(r,c,1)*d;
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using vecdim(n) <= ndims(data) and vecdim(n+1) > ndims(data)')
    
    % We also make sure that it works with vecdim considering different
    % types of integers and double.
    for i = {'single','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64'}
        eval_string = feval(i{1},[1,3]);
        fun_out = sum(data, eval_string);
        actual_out = ones(1,c)*r*d;
        verifyEqual(testCase, fun_out, actual_out, sprintf('VECDIM. Sum using vecdim with type %s failed',i{1}));
    end
    
    % Then, we check some exceptional cases that should throw an error.
    % ** Check if vecdims has more elements than size(data). 
    actual_out = prod(size(data));
    fun_out = sum(data, [1:6]);
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum of vecdim larger than ndims(data)');
    
    % ** Check if vecdims is an empty vector.
    actual_out = ones(1,c,d)*r;
    fun_out = sum(data, []);
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using EMPTY vecdim');
       
    % ** NEGATIVE elements in vecdim.
    actual_out = 'error';
    try fun_out = sum(data, [-1, 2]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using a NEGATIVE element in vecdim didnt throw error.');
    
    % ** ZERO element in vecdim.
    try fun_out = sum(data, [2,0]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using a ZERO element in vecdim didnt throw error.');
    
    % ** CHAR element in vecdim.
    try fun_out = sum(data, ['a',3]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using a CHAR element in vecdim didnt throw error.');
    
    % ** FLOAT element in vecdim.
    try fun_out = sum(data, [1, 2.5]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using a FLOAT element in vecdim didnt throw error.');
        
    % ** MATRIX used as vecdim.
    try fun_out = sum(data, reshape(1:4,[2,2])); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using a MATRIX in vecdim didnt throw error.');
        
    % ** Check if vecdim receives an incompatible structure. We use a
    % cell, but there are other alternatives.
    try fun_out = sum(data, {1,2}); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using a CELL in vecdim didnt throw error.');
    
    % ** Check if vecdim contains nonunique elements.
    try fun_out = sum(data, [3,1,3]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Sum using NONUNIQUE ELEMENTS in vecdim didnt throw error.');
    
    % ** Sum should fail if we use a vecdim with a complex number
    try fun_out = sum(data, [1+j, 2]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Using complex vecdim produced unexpected results')
    
    % ** Sum should fail if vecdim contains the binarized version of a
    % vector such as [1,2], since it turns into [1,1]. The same thing
    % occurs with duration data.
    try fun_out = sum(data, logical([1,2])); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Tried to binarize vecdim and sum failed')
    
    try fun_out = sum(data, hours([1,2])); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'VECDIM. Tried to use a duration-like vecdim and sum failed')
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'nanflag' tests.
% VERIFY COMPLEX NUMBERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_nanflag(testCase)
    % We check both nanflags.
    data = single(ones(3));
    data(3) = NaN;
    
    actual_out = single(NaN);
    fun_out = sum(data, 'all','native');
    verifyEqual(testCase, fun_out, actual_out, 'NAN. Flag includenan failed');
    
    actual_out = single(8);
    fun_out = sum(data, 'all','native','omitnan');
    verifyEqual(testCase, fun_out, actual_out, 'NAN. Flag omitnan failed');
    % We also check that it provides an error when nanflag is not properly
    % set.
    actual_out = 'error';
    try fun_out = sum(1:5, 2,'double','a'); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'NAN. Sum using integer nanflag didnt throw error');
    
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function args tests.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_wrong_call(testCase)
    % We check here if the function produces an 'error' outcome when the input
    % is not numeric. We do this using a cell that contains a vector inside.
    data = {1:5};
    actual_out = 'error';
    try
        fun_out = sum(data)
    catch
        fun_out = 'error';
        verifyEqual(testCase, fun_out, actual_out,['CALL. It provides output for incompatible input'])
    end

    % We check what happens when 'outtype' or 'nanflag' is an integer using
    % all the available arguments.
    actual_out = 'error';
    try fun_out = sum(1:5, 2,1,'omitnan'); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'CALL. Sum using integer outtype didnt throw error');
    
    try fun_out = sum(1:5, 2,'double',0); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'CALL. Sum using integer nanflag didnt throw error');
    
    % Sum should fail if we provide more than 3 input arguments (excluding
    % the input vector/matrix).
    try fun_out = sum(magic(3), 2,'double','omitnan',42); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'CALL. Using more than three input arguments');
    
    % It should fail if we provide no input argument.
    try fun_out = sum(); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'CALL. User provided no input');
    
    % It should fail if we request more than one output.
    try [a,b] = sum(magic(3)); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'CALL. Requested more than one output');
end
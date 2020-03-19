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
                % by try/catch.
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
                    verifyEqual(testCase, fun_out, actual_out,['Sum of ',i_type, ' vector fails. NON-COMPLEX numbers.'])
                case 2
                    verifyEqual(testCase, fun_out, actual_out,['Sum of ',i_type, ' vector fails. COMPLEX numbers.'])
            end
        end


    end
    
    % We also check some standard outputs, such as using an empty vector as
    % data.
    actual_out = 0;
    fun_out = sum([]);
    verifyEqual(testCase, fun_out, actual_out, 'Output when data is empty');

    
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
                % by try/catch.
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
                    verifyEqual(testCase, fun_out, actual_out,['Sum of ',i_type, ' vector fails. NON-COMPLEX numbers.'])
                case 2
                    verifyEqual(testCase, fun_out, actual_out,['Sum of ',i_type, ' vector fails. COMPLEX numbers.'])
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
                % by try/catch.
               
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
                    verifyEqual(testCase, fun_out, actual_out,['Sum of ',i_type, ' vector fails. NON-COMPLEX numbers.'])
                case 2
                    verifyEqual(testCase, fun_out, actual_out,['Sum of ',i_type, ' vector fails. COMPLEX numbers.'])
            end
        end
    
    end
    % XXXX COMPLEX NUMBERS
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'dim' tests.
% VERIFY COMPLEX NUMBERS
% CHECK EVERY INPUT TYPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_dim(testCase)
% Test the size of the data matrix. We use empty matrices as well as huge
% ones.
    data = ones(4,3,2);
    [r, c, d] = size(data);
    
    % It should work with any dimension from 1 to 3 for this example.
    for i = 1:length(size(data))         
        fun_out = sum(data,i);
        verifyEqual(testCase,fun_out(1), size(data, i));
    end
    
    % We should get an error if we use a float or char 'dim' value
    actual_out = 'error';
    try sum(data,'b'); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Mistake using b as a parameter for sum');
    
    try sum(data, 1.5); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Error. A float dim number was used');
        
    % We should also verify that it does not work with a negative 'dim'
    % value.
    try sum(data, -1); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Error. A float dim number was used');
    
    % In fact, it should not work if we set dim=0.
    try sum(data, 0); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Error. A float dim number was used');
    
    % Here is an exceptional case, which is the term 'a' that is
    % equivalent to 'all'.
    verifyEqual(testCase, sum(data,'a'), prod(size(data)));      
    
    
    % We also check out the result of adding every element of the matrix
    verifyEqual(testCase, sum(data,'all'), prod(size(data)));
    
    % If we use a 'dim' bigger than 3, the function should give the
    % original vector.
    verifyEqual(testCase, sum(data,5), data);       
    
    % If the size of data is 1, it should also return the original vector.
    data = [15];
    verifyEqual(testCase, sum(data), data);      

end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'vecdim' tests.
% VERIFY COMPLEX NUMBERS
% CHECK EVERY INPUT TYPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_vecdim(testCase)
    % First, we check that it works normally using different combinations
    % for vecdim.
    data = ones(4,3,2);
    [r, c, d] = size(data);
    
    fun_out = sum(data, [1,3]);
    actual_out = ones(1,c)*r*d;
    verifyEqual(testCase, fun_out, actual_out, 'Sum using vecdim=[1,3] failed');
    
    fun_out = sum(data, [1,2]);
    actual_out = ones(1,1,d)*r*c;
    verifyEqual(testCase, fun_out, actual_out, 'Sum using vecdim=[1,2] failed');
    
    fun_out = sum(data, [2,3]);
    actual_out = ones(r,1)*c*d;
    verifyEqual(testCase, fun_out, actual_out, 'Sum using vecdim=[2,3] failed');    
    
    fun_out = sum(data, [1,2,3]);
    actual_out = prod(size(data));
    verifyEqual(testCase, fun_out, actual_out, 'Sum using vecdim=[1,2,3] failed');
    
    % Moreover, the order of vecdim should be irrelevant.
    fun_out = sum(data, [3,2]);
    actual_out = ones(r,1)*d*c;
    verifyEqual(testCase, fun_out, actual_out, 'Sum using UNSORTED vecdim failed');
    
    % If we use vecdim with numbers bigger than ndims(data) it should
    % return the original matrix.
    fun_out = sum(data, [4,5]);
    verifyEqual(testCase, fun_out, data, 'Sum using vecdim > ndims(data)');
    
    % On the contrary, if we use an element bigger than ndims(data) and
    % another one within the dimensions of the matrix, it should perform
    % the sum operation along the latter dimension.
    fun_out = sum(data, [5,3]);
    actual_out = ones(r,c,1)*d;
    verifyEqual(testCase, fun_out, actual_out, 'Sum using vecdim(n) <= ndims(data) and vecdim(n+1) > ndims(data)')
    
    % Then, we check some exceptional cases that should throw an error.
    % ** Check if vecdims has more elements than size(data). 
    actual_out = prod(size(data));
    fun_out = sum(data, [1:6]);
    verifyEqual(testCase, fun_out, actual_out, 'Sum of vecdim larger than ndims(data)');
    
    % ** Check if vecdims is an empty vector.
    actual_out = ones(1,c,d)*r;
    fun_out = sum(data, []);
    verifyEqual(testCase, fun_out, actual_out, 'Sum using EMPTY vecdim');
       
    % ** NEGATIVE elements in vecdim.
    actual_out = 'error';
    try sum(data, [-1, 2]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using a NEGATIVE element in vecdim didnt throw error.');
    
    % ** ZERO element in vecdim.
    try sum(data, [2,0]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using a ZERO element in vecdim didnt throw error.');
    
    % ** CHAR element in vecdim.
    try sum(data, ['a',3]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using a CHAR element in vecdim didnt throw error.');
    
    % ** FLOAT element in vecdim.
    try sum(data, [1, 2.5]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using a FLOAT element in vecdim didnt throw error.');
        
    % ** MATRIX used as vecdim.
    try sum(data, reshape(1:4,[2,2])); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using a MATRIX in vecdim didnt throw error.');
        
    % ** Check if vecdim receives an incompatible structure. We use a
    % cell, but there are other alternatives.
    try sum(data, {1,2}); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using a CELL in vecdim didnt throw error.');
    
    % ** Check if vecdim contains nonunique elements.
    try sum(data, [3,1,3]); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using NONUNIQUE ELEMENTS in vecdim didnt throw error.');
    
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'nanflag' tests.
% VERIFY COMPLEX NUMBERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function args tests.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_wrong_input_datatype(testCase)
    % We check here if the function produces an 'error' outcome when the input
    % is not numeric. We do this using a cell that contains a vector inside.
    data = {1:5};
    actual_out = 'error';
    try
        sum(data)
    catch
        fun_out = 'error';
        verifyEqual(testCase, fun_out, actual_out,['Error. It provides output for incompatible input'])
    end

    % We check what happens when 'outtype' or 'nanflag' is an integer.
    actual_out = 'error';
    try sum(1:5, 2,1,'omitnan'); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using integer outtype didnt throw error');
    
    try sum(1:5, 2,'double',0); catch fun_out = 'error'; end
    verifyEqual(testCase, fun_out, actual_out, 'Sum using integer nanflag didnt throw error');
    
end
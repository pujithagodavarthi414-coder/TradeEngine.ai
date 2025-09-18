CREATE FUNCTION Ufn_GetWordingOfANumber(@Number numeric)
RETURNS NVARCHAR(MAX)
BEGIN

	DECLARE @InputNumber VARCHAR(38)
	DECLARE @NumbersTable TABLE (number CHAR(2), word VARCHAR(10))
	DECLARE @OutputString VARCHAR(8000)
	DECLARE @Length INT
	DECLARE @Counter INT
	DECLARE @Loops INT
	DECLARE @Position INT
	DECLARE @Chunk CHAR(3) -- for chunks of 3 numbers
	DECLARE @Tensones CHAR(2)
	DECLARE @Hundreds CHAR(1)
	DECLARE @Tens CHAR(1)
	DECLARE @Ones CHAR(1)
	
	SELECT @Number = ROUND(@Number,0)

	DECLARE @IsNegative BIT = IIF(@Number < 0, 1,0)

	SELECT @Number = ABS(@Number)

	IF(@Number = 0)
	BEGIN 

		SELECT @OutputString = 'Zero'

	END
	ELSE
	BEGIN
	
		-- initialize the variables
		SELECT @InputNumber = CONVERT(varchar(38), @Number)
		     , @OutputString = ''
		     , @Counter = 1
		SELECT @Length   = LEN(@InputNumber)
		     , @Position = LEN(@InputNumber) - 2
		     , @Loops    = LEN(@InputNumber)/3
		
		-- make sure there is an extra loop added for the remaining numbers
		IF LEN(@InputNumber) % 3 <> 0 SET @Loops = @Loops + 1
		
		-- insert data for the numbers and words
		INSERT INTO @NumbersTable   SELECT '00', ''
		    UNION ALL SELECT '01', 'One'      UNION ALL SELECT '02', 'Two'
		    UNION ALL SELECT '03', 'Three'    UNION ALL SELECT '04', 'Four'
		    UNION ALL SELECT '05', 'Five'     UNION ALL SELECT '06', 'Six'
		    UNION ALL SELECT '07', 'Seven'    UNION ALL SELECT '08', 'Eight'
		    UNION ALL SELECT '09', 'Nine'     UNION ALL SELECT '10', 'Ten'
		    UNION ALL SELECT '11', 'Eleven'   UNION ALL SELECT '12', 'Twelve'
		    UNION ALL SELECT '13', 'Thirteen' UNION ALL SELECT '14', 'Fourteen'
		    UNION ALL SELECT '15', 'Fifteen'  UNION ALL SELECT '16', 'Sixteen'
		    UNION ALL SELECT '17', 'Seventeen' UNION ALL SELECT '18', 'Eighteen'
		    UNION ALL SELECT '19', 'Nineteen' UNION ALL SELECT '20', 'Twenty'
		    UNION ALL SELECT '30', 'Thirty'   UNION ALL SELECT '40', 'Forty'
		    UNION ALL SELECT '50', 'Fifty'    UNION ALL SELECT '60', 'Sixty'
		    UNION ALL SELECT '70', 'Seventy'  UNION ALL SELECT '80', 'Eighty'
		    UNION ALL SELECT '90', 'Ninety'   
		
		WHILE @Counter <= @Loops BEGIN
		
			-- get chunks of 3 numbers at a time, padded with leading zeros
			SET @Chunk = RIGHT('000' + SUBSTRING(@InputNumber, @Position, 3), 3)
		
			IF @Chunk <> '000' BEGIN
				SELECT @Tensones = SUBSTRING(@Chunk, 2, 2)
				     , @Hundreds = SUBSTRING(@Chunk, 1, 1)
				     , @Tens = SUBSTRING(@Chunk, 2, 1)
				     , @Ones = SUBSTRING(@Chunk, 3, 1)
		
				-- If twenty or less, use the word directly from @NumbersTable
				IF CONVERT(INT, @Tensones) <= 20 OR @Ones='0' BEGIN
					SET @OutputString = (SELECT word 
		                                      FROM @NumbersTable 
		                                      WHERE @Tensones = number)
		                   + CASE @Counter WHEN 1 THEN '' -- No name
		                       WHEN 2 THEN ' Thousand ' WHEN 3 THEN ' Million '
		                       WHEN 4 THEN ' Billion '  WHEN 5 THEN ' Trillion '
		                       WHEN 6 THEN ' Quadrillion ' WHEN 7 THEN ' Quintillion '
		                       WHEN 8 THEN ' Sextillion '  WHEN 9 THEN ' Septillion '
		                       WHEN 10 THEN ' Octillion '  WHEN 11 THEN ' Nonillion '
		                       WHEN 12 THEN ' Decillion '  WHEN 13 THEN ' Undecillion '
		                       ELSE '' END
		                               + @OutputString
				    END
				 ELSE BEGIN -- break down the ones and the tens separately
		
		             SET @OutputString = ' ' 
		                            + (SELECT word 
		                                    FROM @NumbersTable 
		                                    WHERE @Tens + '0' = number)
							         + ' '
		                             + (SELECT word 
		                                    FROM @NumbersTable 
		                                    WHERE '0'+ @Ones = number)
		                   + CASE @Counter WHEN 1 THEN '' -- No name
		                       WHEN 2 THEN ' Thousand ' WHEN 3 THEN ' Million '
		                       WHEN 4 THEN ' Billion '  WHEN 5 THEN ' Trillion '
		                       WHEN 6 THEN ' Quadrillion ' WHEN 7 THEN ' Quintillion '
		                       WHEN 8 THEN ' Sextillion '  WHEN 9 THEN ' Septillion '
		                       WHEN 10 THEN ' Octillion '  WHEN 11 THEN ' Nonillion '
		                       WHEN 12 THEN ' Decillion '   WHEN 13 THEN ' Undecillion '
		                       ELSE '' END
		                            + @OutputString
				END
		
				-- now get the hundreds
				IF @Hundreds <> '0' BEGIN
					SET @OutputString  = (SELECT word 
		                                      FROM @NumbersTable 
		                                      WHERE '0' + @Hundreds = number)
							            + ' Hundred ' 
		                                + @OutputString
				END
			END
		
			SELECT @Counter = @Counter + 1
			     , @Position = @Position - 3
		
		END
	END
	
	-- Remove any double spaces
	SET @OutputString = LTRIM(RTRIM(REPLACE(@OutputString, '  ', ' ')))
	SET @OutputString = UPPER(LEFT(@OutputString, 1)) + SUBSTRING(@OutputString, 2, 8000)
	
	IF(@IsNegative = 1) SELECT @OutputString = 'Minus ' + @OutputString

	RETURN @OutputString

END

CREATE FUNCTION Ufn_GetCurrency
(
	@CurrencyCode NVARCHAR(100),
	@Amount FLOAT,
	@IsCurrencySymbolRequired BIT = NULL
)
RETURNS NVARCHAR(MAX)
BEGIN

	DECLARE @Currency NVARCHAR(MAX), @DisplayFormat NVARCHAR(MAX), @IsNegative BIT

	--IF(@Amount IS NULL) SET @Amount = 0

	SELECT @IsNegative = IIF(@Amount < 0, 1,0)

	SELECT @DisplayFormat = DisplayFormat FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode

	IF(@CurrencyCode IS NULL)
	BEGIN
	SET @CurrencyCode = 'INR'
	SET @DisplayFormat = (SELECT DisplayFormat FROM SYS_Currency WHERE CurrencyCode = 'INR')
	END
	
	SELECT @DisplayFormat = REPLACE(@DisplayFormat,',','-')
	
	SELECT @Currency = CAST(FORMAT(@Amount,@DisplayFormat) AS NVARCHAR(MAX)) FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode

	--IF(@IsCurrencySymbolRequired = 1) SELECT @Currency = Symbol + CAST(FORMAT(@Amount,@DisplayFormat) AS NVARCHAR(MAX)) 
	--                                  FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode
	--ELSE SELECT @Currency = CAST(FORMAT(@Amount,@DisplayFormat) AS NVARCHAR(MAX)) FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode

	IF(SUBSTRING(@Currency, 1, 3) = '---') SELECT @Currency = RIGHT(@Currency, len(@Currency)-3)
	ELSE IF(SUBSTRING(@Currency, 1, 2) = '--') SELECT @Currency = RIGHT(@Currency, len(@Currency)-2)
	ELSE IF(SUBSTRING(@Currency, 1, 1) = '-') SELECT @Currency = RIGHT(@Currency, len(@Currency)-1)

	SELECT @Currency = REPLACE(@Currency,'-',',')

	IF(@Currency = '') SET @Currency = '0'

	IF(@Currency LIKE '%.%') SELECT @Currency = @Currency
	ELSE SELECT @Currency = @Currency + '.00'

	IF(@IsCurrencySymbolRequired = 1) SELECT @Currency = Symbol + @Currency FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode

	IF(@IsNegative = 1) SELECT @Currency = '-' + @Currency
	ELSE SELECT @Currency = @Currency

	RETURN @Currency	

END
GO
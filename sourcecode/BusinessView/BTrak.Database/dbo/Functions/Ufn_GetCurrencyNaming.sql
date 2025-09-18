CREATE FUNCTION Ufn_GetCurrencyNaming
(
	@CurrencyCode NVARCHAR(100),
	@Amount numeric,
	@IsFront BIT = NULL
)
RETURNS NVARCHAR(MAX)
BEGIN

	DECLARE @Currency NVARCHAR(MAX)

	IF(@IsFront = 1) SELECT @Currency = CurrencyNaming + 's ' + dbo.Ufn_GetWordingOfANumber(@Amount) + ' Only' FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode
	ELSE SELECT @Currency = dbo.Ufn_GetWordingOfANumber(@Amount) + ' ' + CurrencyNaming +  's Only' FROM SYS_Currency WHERE CurrencyCode = @CurrencyCode

	RETURN @Currency

END
GO
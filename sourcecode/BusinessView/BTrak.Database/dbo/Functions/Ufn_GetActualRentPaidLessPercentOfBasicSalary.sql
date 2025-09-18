CREATE FUNCTION [dbo].[Ufn_GetActualRentPaidLessPercentOfBasicSalary]
(
	@BasicValue FLOAT,
	@PercentageOnBasic FLOAT,
	@RentalValue FLOAT
)
RETURNS FLOAT
BEGIN

	DECLARE @RentPaidLessPercentOfBasicSalary FLOAT = @RentalValue - (@BasicValue * @PercentageOnBasic * 0.01)

	RETURN ROUND(@RentPaidLessPercentOfBasicSalary,0)

END
CREATE FUNCTION [dbo].[Ufn_CapitalizeEachWord]
(
	@FeatureName NVARCHAR(500)
)
RETURNS NVARCHAR(500)
AS
BEGIN
	
	DECLARE @CamelCaseFeatureName NVARCHAR(500) = ''

	SELECT @CamelCaseFeatureName = @CamelCaseFeatureName + UPPER(LEFT([Value],1))+LOWER(SUBSTRING([Value],2,LEN([Value]))) FROM [dbo].[Ufn_StringSplit](@FeatureName,' ')
	
	RETURN @CamelCaseFeatureName

END
GO

--SELECT [dbo].[Ufn_BranchDeleteValidation]('10AC1823-AA3B-4E8A-BDDB-F80B50F00352')
CREATE FUNCTION [dbo].[Ufn_BranchDeleteValidation]
(
	@BranchId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(250)
AS
BEGIN

	DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	 	
	IF(EXISTS(SELECT Id FROM EmployeeBranch WHERE BranchId = @BranchId))
	BEGIN
	
		SET @IsEligibleToArchive = 'ThisBranchUsedInEmployeeBranchPleaseDeleteTheDependenciesAndTryAgain'
	
	END
	ELSE IF(EXISTS(SELECT Id FROM SeatingArrangement WHERE BranchId = @BranchId))
	BEGIN
	
		SET @IsEligibleToArchive = 'ThisBranchUsedInSeatingArrangementPleaseDeleteTheDependenciesAndTryAgain'
	
	END
	ELSE IF(EXISTS(SELECT Id FROM SoftLabel WHERE BranchId = @BranchId))
	BEGIN
	
		SET @IsEligibleToArchive = 'ThisBranchUsedInSoftLabelPleaseDeleteTheDependenciesAndTryAgain'
	
	END
	ELSE IF(EXISTS(SELECT Id FROM Asset WHERE BranchId = @BranchId))
	BEGIN
	
		SET @IsEligibleToArchive = 'ThisBranchUsedInAssetPleaseDeleteTheDependenciesAndTryAgain'
	
	END

	RETURN @IsEligibleToArchive

END
GO
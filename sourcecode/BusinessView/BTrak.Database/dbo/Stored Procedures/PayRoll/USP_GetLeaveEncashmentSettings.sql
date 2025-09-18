-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-02-19 00:00:00.000'
-- Purpose      To Save or Update LeaveEncashmentSettings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetLeaveEncashmentSettings] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLeaveEncashmentSettings]
(
    @LeaveEncashmentSettingsId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@LeaveEncashmentSettingsId = '00000000-0000-0000-0000-000000000000') SET @LeaveEncashmentSettingsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT LES.Id AS LeaveEncashmentSettingsId,
		   	      LES.PayRollComponentId,
				  PC.[ComponentName] PayRollComponentName,
		   	      LES.[IsCtcType],
				  LES.[Percentage],			
		   	      LES.InActiveDateTime,
		   	      LES.CreatedDateTime ,
		   	      LES.CreatedByUserId,
				  LES.ActiveFrom,
				  LES.ActiveTo,
		   	      LES.[TimeStamp],
				  LES.[BranchId],
				  BR.[BranchName],
	              LES.[Amount],
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,LES.Amount,1) ModifiedAmount,
				  (CASE WHEN LES.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
				  (CASE WHEN LES.Amount IS NOT NULL THEN LES.Amount WHEN LES.[Percentage] IS NOT NULL THEN  LES.[Percentage] ELSE NULL END) As [Value],
				  (CASE WHEN LES.Amount IS NOT NULL THEN 0 WHEN LES.[Percentage] IS NOT NULL THEN  1 ELSE NULL END) As [Type],
				  (CASE WHEN LES.PayRollComponentId IS NOT NULL THEN 0 WHEN LES.IsCtcType = 1 THEN  1 ELSE NULL END) As [DependentType],	
		   	      TotalCount = COUNT(1) OVER()
           FROM LeaveEncashmentSettings AS LES	
		   LEFT JOIN PayrollComponent PC ON PC.Id = LES.PayRollComponentId
		   JOIN Branch BR ON BR.Id = LES.BranchId 
		   INNER JOIN Company COM on COM.Id = BR.CompanyId
		   LEFT JOIN Currency CU on CU.Id = COM.CurrencyId
           WHERE BR.CompanyId = @CompanyId 
		        AND (@SearchText IS NULL OR (PC.[ComponentName] LIKE  @SearchText))
		   	    AND (@LeaveEncashmentSettingsId IS NULL OR LES.Id = @LeaveEncashmentSettingsId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND LES.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND LES.InActiveDateTime IS NULL))	   	    
           ORDER BY LES.CreatedDateTime DESC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
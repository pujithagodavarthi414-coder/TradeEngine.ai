---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-21 00:00:00.000'
-- Purpose      To Get the EntityTypeFeatures by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEntityFeatures] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEntityFeatures]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(250)  = NULL,
	@EntityFeatureId UNIQUEIDENTIFIER = NULL,
	@EntityTypeId  UNIQUEIDENTIFIER = NULL,
	@EntityFeatureName NVARCHAR(250) = NULL,		
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
		  
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		    DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
            DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
            DECLARE @EnableBugboard BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
            DECLARE @EnableAuditManagement BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableAuditManagement%')
          
		    DECLARE @EnableProject BIT = (SELECT CASE WHEN EXISTS(SELECT ModuleId FROM CompanyModule WHERE ModuleId = '3926F534-EDE8-4C47-8A44-BFDD2B7F76DB' AND CompanyId = @CompanyId AND IsActive = 1) 
			                                                 THEN 1 ELSE 0 END)
         
           SELECT ETF.Id AS EntityFeatureId,
		   	      ETF.EntityTypeId,
				  ETF.EntityFeatureName,
		   	      CASE WHEN ETF.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  ETF.ParentFeatureId,
		   	      ETF.CreatedDateTime,
		   	      ETF.CreatedByUserId,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[EntityFeature] AS ETF		        
		   WHERE  (@EntityFeatureId IS NULL OR ETF.Id = @EntityFeatureId)
				AND (@EntityTypeId IS NULL OR ETF.EntityTypeId = @EntityTypeId)
		        AND (@EntityFeatureName IS NULL OR ETF.EntityFeatureName = @EntityFeatureName)
				AND (@EnableSprints = 1 OR ((@EnableSprints = 0 OR @EnableSprints IS NULL) AND ETF.Id NOT IN ('E74DEA02-4ED0-4276-B4A9-1DFD433BB00F','886D8B4F-26F0-4B89-B8F2-2F77F896353C','E769DD87-69C4-49B7-85B4-56F2170D4799',
				   'FBC59404-079C-4C1D-866A-7129FFB06450','5470F248-356B-43A0-81DC-D261316411B5','0B9A3D23-EDFF-456A-9D69-D8F2E9D7784F','220A1FCE-87F4-4FB2-A171-EC242E1CA035','F683B9DD-C302-45B4-90B8-F0737644806D','611DB8EA-A237-478A-ACEC-F295D996A869','693D3FE7-79CB-48BA-A1F2-5CE15AE3B1ED')))
				AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL)
				AND ETF.Id NOT IN ('B90731AE-6B56-4D3B-8E99-0D625A999DD2','AB90D413-5021-4232-ACAB-11E11E9A59E6','A7758D2F-D23B-458A-B0EC-230ED046B51B','CB4F95E1-08E8-46CD-A25A-352EAED56505','CA9DBDDE-0B61-4916-B494-3EA374A9065C','BA495879-FC48-4231-BCCB-5DA604490456','71F29ABA-13FD-42A0-BA92-6474694FFECE','8F3B039E-B17A-454A-BD3E-76BE6FD35484
                    8F3B039E-B17A-454A-BD3E-76BE6FD35484','876C0F6B-846D-4CBD-AD1B-7B49F3D3B978','7ADB5FC3-4C21-48FE-A8BB-7E81217F2E91','1E618A6C-E653-44DB-BFBB-82A7F0412041','EB37496A-D573-499A-8804-8C44504DA450','CFD6FA63-25BC-4953-9B75-973114563793','4F98F22B-6096-45A0-BF30-9B6045366AD3','40EE305F-1E25-4277-9FA7-A57029C04232','3D2853EE-527C-4AA3-BF83-A939F7834CC3'
                   ,'3781D0EB-5A9D-4117-A9BF-C04F6185E93E','C0828385-B5D2-4176-8653-C65A6A586EF0','B76F1702-5F5C-466B-97D7-DF369C2A8A32','FF8A0BE1-2A5D-4E53-B71C-E21CBEE9DF61','52CEB43F-29F6-493E-B5F8-0913BD44862A')))
				AND (@EnableBugboard = 1 OR ((@EnableBugboard = 0 OR @EnableBugboard IS NULL) AND ETF.Id NOT IN ('C822AEB4-450D-480C-91F6-4C19685A5A86','DE0B4567-1F9F-4A38-A703-920269529FD8','BC5FA038-0782-4FC7-829A-C3D7FC0B7E93','18B6005D-330B-4BAF-B88A-CA3AD027EE4B','721BBAA0-E2F9-4F5A-AACE-E89686F52A61','E862D8EC-463C-4179-BBBC-FB9E60120EC5')))
		        AND (@EnableAuditManagement = 1 OR (ETF.ParentFeatureId <> 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2' OR ETF.Id <> 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2'))
				AND (@SearchText IS NULL OR ETF.EntityFeatureName LIKE  '%'+ @SearchText +'%')
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ETF.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ETF.InActiveDateTime IS NULL))
		   	    AND (@EnableProject = 1 OR (ETF.Id  IN ( 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2') OR ETF.ParentFeatureId  IN ( 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2')))
           ORDER BY ETF.EntityFeatureName ASC

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
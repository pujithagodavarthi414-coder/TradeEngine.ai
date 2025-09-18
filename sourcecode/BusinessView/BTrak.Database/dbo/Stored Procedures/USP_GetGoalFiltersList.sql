CREATE PROCEDURE [dbo].[USP_GetGoalFiltersList]
    @GoalFilterId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	  
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        IF (@HavePermission = '1')
        BEGIN
		 IF(@GoalFilterId = '00000000-0000-0000-0000-000000000000') SET @GoalFilterId = NULL

		   SELECT GF.Id AS GoalFilterId,
		          GF.GoalFilterName,
				  GF.IsPublic,
				  UGF.Id AS GoalFilterDetailsId,
				  UGF.GoalFilterJson AS GoalFilterDetailsJson,
				  GF.CreatedByUserId,
				  U.FirstName + ''+U.SurName AS FullName,
				  UGF.CreatedDateTime
				FROM [dbo].[GoalFilter]GF
				INNER JOIN [dbo].[UserGoalFilter]UGF ON GF.Id = UGF.GoalFilterId
				INNER JOIN [dbo].[User]U ON GF.CreatedByUserId = U.Id
				WHERE (GF.CreatedByUserId = @OperationsPerformedBy OR GF.IsPublic = 1)
				AND U.CompanyId = @CompanyId
				AND (@GoalFilterId IS NULL OR GF.Id = @GoalFilterId)
				AND GF.InActiveDateTime IS NULL
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
	

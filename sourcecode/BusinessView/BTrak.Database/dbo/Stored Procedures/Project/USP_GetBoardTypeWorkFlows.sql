-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Get The WBoardTypeWorkFlows By Appliying BoardTypeWorkFlowId Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBoardTypeWorkFlows] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBoardTypeWorkFlows]
(
	@BoardTypeId UNIQUEIDENTIFIER = NULL,
	@WorkflowId UNIQUEIDENTIFIER = NULL,
	@BoardTypeUiId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

     SET NOCOUNT ON

     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                    
        IF (@HavePermission = '1')
        BEGIN

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@BoardTypeId = '00000000-0000-0000-0000-000000000000') SET  @BoardTypeId = NULL

	      IF(@WorkflowId = '00000000-0000-0000-0000-000000000000') SET  @WorkflowId = NULL

		  IF(@BoardTypeUiId = '00000000-0000-0000-0000-000000000000') SET  @BoardTypeUiId = NULL

	      SELECT BW.Id AS BoardTypeWorkFlowId,
				 BW.BoardTypeId,
                 BW.WorkflowId,
				 BW.CreatedByUserId,
				 BW.CreatedDateTime,
				 BW.UpdatedByUserId,
				 BW.UpdatedDateTime,
				 B.BoardTypeName,
                 B.BoardTypeUIId,
                 CASE WHEN B.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS BoardTypeIsArchive,
                 BTU.BoardTypeUIName AS BoardTypeUI,
				 BTU.BoardTypeUiView,
                 W.WorkFlow AS WorkflowName,
				 W.CompanyId,
				 CASE WHEN W.InactiveDateTime IS NULL THEN 0 ELSE 1 END  AS WorkFlowIsArchived,
				 BW.[TimeStamp],
				 CASE WHEN BW.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
                 TotalCount = Count(1) OVER()
          FROM [dbo].[BoardTypeWorkFlow] BW WITH (NOLOCK)
               INNER JOIN [dbo].[WorkFlow] W ON W.Id = BW.WorkflowId AND W.InactiveDateTime IS NULL
               INNER JOIN [dbo].[BoardType] B ON B.Id = BW.BoardTypeId AND B.InActiveDateTime IS NULL
               LEFT JOIN [dbo].[BoardTypeUi] BTU ON BTU.Id = B.BoardTypeUIId AND BTU.InActiveDateTime IS NULL
          WHERE W.CompanyId = @CompanyId 
                AND (@BoardTypeId IS NULL OR BW.BoardTypeId = @BoardTypeId)
                AND (@WorkflowId IS NULL OR BW.WorkflowId = @WorkflowId)
                AND (@IsArchived IS NULL OR (W.InActiveDateTime IS NOT NULL AND @IsArchived = 1) OR (W.InActiveDateTime IS NULL AND @IsArchived = 0))

	 END
	 ELSE

	    RAISERROR(@HavePermission,11,1)

	 END TRY  
	 BEGIN CATCH 
		
		THROW

	END CATCH

END
GO
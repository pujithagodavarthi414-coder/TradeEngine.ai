-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Get The GetBoardTypes By Appliying BoardTypeWorkFlowId Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetBoardTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetBoardTypes]
(
    @BoardTypeId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @BoardTypeUIId UNIQUEIDENTIFIER = NULL,
    @BoardTypeName NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
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
		  DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')


          IF (@BoardTypeId = '00000000-0000-0000-0000-000000000000') SET @BoardTypeId = NULL

          IF (@BoardTypeUIId = '00000000-0000-0000-0000-000000000000') SET @BoardTypeUIId = NULL

          IF (@BoardTypeName = '') SET @BoardTypeName = NULL

		  IF(@IsArchived = '') SET  @IsArchived = NULL

          SELECT BT.Id AS BoardTypeId,
                 BT.BoardTypeName,
                 CASE WHEN BT.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
                 BT.BoardTypeUIId,
                 BT.CompanyId,
                 BT.CreatedDatetime,
                 BT.CreatedByUserId,
				 BTU.BoardTypeUiName,
				 BTF.WorkFlowId as WorkFlowId,
				 W.Workflow as WorkFlowName,
				 BT.[TimeStamp],
				 BT.IsBugBoard,
                 BT.IsSuperAgileBoard,
                 BT.IsDefault,
				 CASE WHEN BT.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS  IsArchived,
                 TotalCount = COUNT(1) OVER()
           FROM [dbo].[BoardType]BT WITH (NOLOCK)
		        LEFT JOIN [dbo].[BoardTypeWorkFlow]BTF ON BTF.BoardTypeId = BT.Id AND BTF.InActiveDateTime IS NULL
		        LEFT JOIN [dbo].[WorkFlow]W ON W.Id = BTF.WorkFlowId AND W.InActiveDateTime IS NULL
		        LEFT JOIN [dbo].[BoardTypeUI]BTU ON BTU.Id = BT.BoardTypeUIId AND BTU.InActiveDateTime IS NULL
          WHERE (@BoardTypeUIId IS NULL OR BT.BoardTypeUIId = @BoardTypeUIId) 
                AND (@BoardTypeId IS NULL OR BT.Id = @BoardTypeId)
                AND (@BoardTypeName IS NULL OR BT.BoardTypeName = @BoardTypeName)
				AND (@IsArchived IS NULL OR (BT.InActiveDateTime IS NULL AND @IsArchived = 0) OR (BT.InActiveDateTime IS NOT NULL AND @IsArchived = 1))
                AND BT.CompanyId = @CompanyId 
				AND (@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULl)))
		  ORDER BY BoardTypeName ASC 

	 END

	 ELSE
	    
		RAISERROR(@HavePermission,11,1)

     END TRY
     BEGIN CATCH
        
          THROW

    END CATCH
END
GO
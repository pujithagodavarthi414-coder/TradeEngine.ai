-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Get the BoardType By Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBoardTypeById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BoardTypeId='F28643CA-9F23-42E0-B51E-03F82A99A281'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBoardTypeById]
(
	@BoardTypeId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

    SET NOCOUNT ON
	 BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SELECT BT.Id as BoardTypeId,
                 BT.BoardTypeName,
                 BT.BoardTypeUIId,
                 BT.CompanyId,
				 CASE WHEN BT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                 BT.CreatedDatetime,
                 BT.CreatedByUserId,
				 BTU.BoardTypeUiName,
				 BTF.WorkFlowId as WorkFlowId,
				 W.Workflow as WorkFlowName,
                 TotalCount = COUNT(1) OVER()
	     FROM  [dbo].[BoardType]BT WITH (NOLOCK)
		  LEFT JOIN [dbo].[BoardTypeWorkFlow]BTF ON BTF.BoardTypeId = BT.Id
		  LEFT JOIN [dbo].[WorkFlow]W ON W.Id = BTF.WorkFlowId
		  LEFT JOIN [dbo].[BoardTypeUI]BTU ON BTU.Id = BT.BoardTypeUIId
	    WHERE BT.[Id] = @BoardTypeId
			  AND BT.CompanyId = @CompanyId

	END TRY  
	BEGIN CATCH 
		
		 SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH

END
GO

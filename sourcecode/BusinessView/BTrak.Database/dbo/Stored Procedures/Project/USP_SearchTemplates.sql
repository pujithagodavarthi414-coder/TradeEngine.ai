CREATE PROCEDURE [dbo].[USP_SearchTemplates]
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@TemplateId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN

       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))  

	    IF(@TemplateId = '00000000-0000-0000-0000-000000000000') SET @TemplateId = NULL
          
        IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
		                                 
										 SELECT T.Id AS TemplateId,
										        T.TemplateName,
												T.TemplateResponsibleUserId,
												T.BoardTypeId,
												T.OnBoardProcessDate,
												T.ProjectId,
												BT.IsBugBoard,
												BT.IsSuperAgileBoard,
												BT.BoardTypeName,
												BT.BoardTypeUIId,
												BTW.WorkFlowId,
												BT.IsBugBoard,
												T.CreatedDateTime,
												T.CreatedByUserId,
												T.TimeStamp
										 FROM [dbo].[Templates]T
										INNER JOIN [dbo].[Project]P ON P.Id = T.ProjectId
										INNER JOIN [dbo].[BoardType]BT ON BT.Id = T.BoardTypeId
										INNER JOIN [dbo].[BoardTypeWorkFlow]BTW ON BTW.BoardTypeId = BT.Id
		                     WHERE (@ProjectId IS NULL OR T.ProjectId = @ProjectId)
							   AND (@TemplateId IS NULL OR T.Id = @TemplateId)
							   AND T.InActiveDateTime IS NULL
    
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
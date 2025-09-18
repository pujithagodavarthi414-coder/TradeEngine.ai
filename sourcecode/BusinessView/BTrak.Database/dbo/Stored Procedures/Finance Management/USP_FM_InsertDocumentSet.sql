--CREATE PROCEDURE [dbo].[USP_FM_InsertDocumentSet]
--(
--  @ReferenceId UNIQUEIDENTIFIER,
--  @ReferenceTypeId UNIQUEIDENTIFIER,
--  @FileId UNIQUEIDENTIFIER,
--  @FolderId UNIQUEIDENTIFIER = NULL,
--  @OperationsPerformedBy UNIQUEIDENTIFIER,
--  @FeatureId UNIQUEIDENTIFIER
--)
--AS 
--BEGIN    
--	SET NOCOUNT ON
--	BEGIN TRY
    
--          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
--          IF(@HavePermission = '1')
--          BEGIN

--			      DECLARE @Currentdate DATETIME = GETDATE()
     	          
--				  DECLARE @NewDocumentSetId UNIQUEIDENTIFIER = NEWID()

--		          INSERT INTO [dbo].[DocumentSet](
--			        		     [Id],	
--                                 [FileId],
--								 [RootFolderId],
--                                 [ReferenceId],	
--                                 [ReferenceTypeId],
--                                 [CreatedDateTime],	
--                                 [CreatedByUserId],	
--                                 [VersionNumber],	
--                                 [OriginalId])
--                          SELECT @NewDocumentSetId,
--								 @FileId,	
--			        			 @FolderId,	
--			        			 @ReferenceId,	
--			        			 @ReferenceTypeId,	
--			        			 @Currentdate,	
--			        			 @OperationsPerformedBy,	
--			        			 1,
--			        			 @NewDocumentSetId
		         
--          END
--		  ELSE
--		  BEGIN

--		       RAISERROR (@HavePermission,10, 1)

--		  END

--	END TRY  
--	BEGIN CATCH 
		
--		  EXEC USP_GetErrorInformation

--	END CATCH
--END

CREATE PROCEDURE [dbo].[USP_UpsertInterviewTypeRoleCofiguration]
(
   @InterviewTypeRoleCofigurationId UNIQUEIDENTIFIER = NULL,
   @RoleId XML = NULL,
   @InterviewTypeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@RoleId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'RoleId')

		END
		IF(@InterviewTypeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewTypeId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @InterviewTypeRoleCofigurationIdCount INT = (SELECT COUNT(1) FROM InterviewTypeRoleCofiguration  WHERE Id = @InterviewTypeRoleCofigurationId)

			--DECLARE @InterviewTypeRoleCofigurationCount INT = (SELECT COUNT(1) FROM InterviewTypeRoleCofiguration WHERE RoleId = @RoleId AND InterviewTypeId = @InterviewTypeId AND (@InterviewTypeRoleCofigurationId IS NULL OR @InterviewTypeRoleCofigurationId <> Id))
       
			IF(@InterviewTypeRoleCofigurationIdCount = 0 AND @InterviewTypeRoleCofigurationId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewTypeRoleCofiguration')

			END
			--IF (@InterviewTypeRoleCofigurationCount > 0)
			--BEGIN

			--	RAISERROR(50001,11,1,'InterviewTypeRoleCofiguration')

			--END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   --DECLARE @IsLatest BIT = (CASE WHEN @InterviewTypeRoleCofigurationId IS NULL THEN 1 
						 --                        ELSE CASE WHEN (SELECT [TimeStamp] FROM [InterviewTypeRoleCofiguration] 
							--					 WHERE Id = @InterviewTypeRoleCofigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   --IF(@IsLatest = 1)
				   --BEGIN
				   
					
                                  DECLARE @RoleIdsList TABLE
					            (
									[Id] UNIQUEIDENTIFIER
					            )
							   
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@InterviewTypeRoleCofigurationId IS NULL)
					  BEGIN

						 --SET @InterviewTypeRoleCofigurationId = NEWID()
						 
							   INSERT INTO @RoleIdsList
							   ([Id])
                                   SELECT X.Y.value('(text())[1]','UNIQUEIDENTIFIER')
                                   FROM @RoleId.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)


						UPDATE [InterviewTypeRoleCofiguration] SET InactiveDateTime = @Currentdate,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE [InterviewTypeId] = @InterviewTypeId 
						AND ID NOT IN (SELECT Id FROM @RoleIdsList)

								INSERT INTO [dbo].[InterviewTypeRoleCofiguration](
                                               [Id]
											   ,[InterviewTypeId]
                                               ,[RoleId]
											   ,CreatedByUserId
											   ,CreatedDateTime
                                               )
                                   SELECT NEWID()
										  ,@InterviewTypeId
										  ,X.Y.value('(text())[1]','UNIQUEIDENTIFIER')
										  ,@OperationsPerformedBy
										  ,@Currentdate
                                   FROM @RoleId.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)

							         
					END
					ELSE
					BEGIN

							   INSERT INTO @RoleIdsList
							   ([Id])
                                   SELECT X.Y.value('(text())[1]','UNIQUEIDENTIFIER')
                                   FROM @RoleId.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)


						UPDATE [InterviewTypeRoleCofiguration] SET InactiveDateTime = @Currentdate,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE [InterviewTypeId] = @InterviewTypeId 
						AND ID NOT IN (SELECT Id FROM @RoleIdsList)

								INSERT INTO [dbo].[InterviewTypeRoleCofiguration](
                                               [Id]
											   ,[InterviewTypeId]
                                               ,[RoleId]
											   ,CreatedByUserId
											   ,CreatedDateTime
                                               )
                                   SELECT NEWID()
										  ,@InterviewTypeId
										  ,Id
								          ,@OperationsPerformedBy
										  ,@Currentdate
								FROM @RoleIdsList 
								WHERE Id NOT IN (Select Id From [InterviewTypeRoleCofiguration] 
													WHERE [InterviewTypeId]=@InterviewTypeId AND InActiveDateTime IS NULL)


					END
				            
				    --SELECT Id FROM [dbo].[InterviewTypeRoleCofiguration] WHERE Id = @InterviewTypeRoleCofigurationId
				                   
				--  END
				--  ELSE
				     
				--      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO

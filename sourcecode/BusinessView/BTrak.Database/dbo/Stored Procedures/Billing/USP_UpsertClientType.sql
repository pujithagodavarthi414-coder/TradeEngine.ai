CREATE PROCEDURE [dbo].[USP_UpsertClientType]
(
   @ClientTypeId UNIQUEIDENTIFIER = NULL,
   @ClientTypeName NVARCHAR(50) = NULL,  
   @ClientTypeRoles NVARCHAR(MAX) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@ClientTypeName = '') SET @ClientTypeName = NULL
		IF(@ClientTypeRoles = '') SET @ClientTypeRoles = NULL
		

	    IF(@ClientTypeName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ClientTypeName')

		END
		ELSE
		BEGIN
		 
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ClientTypeIdCount INT = (SELECT COUNT(1) FROM ClientType  WHERE Id = @ClientTypeId)
        
		DECLARE @NameCount INT = (SELECT COUNT(1) FROM ClientType WHERE ClientTypeName = @ClientTypeName AND InactiveDateTime IS NULL
		                                       AND CompanyId = @CompanyId AND (@ClientTypeId IS NULL OR Id <> @ClientTypeId))       
       
	    IF(@ClientTypeIdCount = 0 AND @ClientTypeId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'ClientType')
        END
        ELSE IF(@NameCount>0)
        BEGIN
        
          RAISERROR(50001, 16 ,1 ,'ClientType')
           
         END
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	     IF(EXISTS(SELECT Id FROM [Client] WHERE ClientTypeId = @ClientTypeId AND InactiveDateTime IS NULL) AND @IsArchived=1)
	     BEGIN
	     
	     SET @IsEligibleToArchive = 'ThisClientTypeUsedInClientsPleaseDeleteTheDependenciesAndTryAgain'
	     RAISERROR (@isEligibleToArchive,11, 1)
	     END
         ELSE
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @ClientTypeId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM ClientType WHERE Id = @ClientTypeId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                    IF (@ClientTypeId IS NULL)
					BEGIN
					
					SET @ClientTypeId = NEWID()
             INSERT INTO [dbo].ClientType(
                         [Id],
						 [Order],
						 [CompanyId],
						 [ClientTypeName],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]				
						 )
                  SELECT @ClientTypeId,
						(SELECT Max([Order])+1 FROM ClientType WHERE CompanyId=@CompanyId),
						 @CompanyId,
						 @ClientTypeName,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy		

						INSERT INTO [ClientTypeRoles]
						(Id
						,RoleId
						,ClientTypeId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,Id
							   ,@ClientTypeId
							   ,@OperationsPerformedBy
							   ,@Currentdate
							FROM dbo.UfnSplit(@ClientTypeRoles)
			            

					
					END
					ELSE
					BEGIN

					UPDATE [dbo].ClientType
						SET [CompanyId]					= 	   @CompanyId,
							ClientTypeName						= 	   @ClientTypeName,
							[InActiveDateTime]			= 	   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
							[UpdatedDateTime]			= 	   @Currentdate,
							[UpdatedByUserId]			= 	   @OperationsPerformedBy
							WHERE (Id = @ClientTypeId)

							DECLARE @RoleIdsList TABLE
					            (
					               RoleId UNIQUEIDENTIFIER
					            )
                          
					INSERT INTO @RoleIdsList(RoleId)
					SELECT Id FROM dbo.UfnSplit(@ClientTypeRoles)

					UPDATE [ClientTypeRoles] SET InactiveDateTime = @Currentdate
					                               ,[UpdatedDateTime] = @Currentdate
					           				       ,[UpdatedByUserId] = @OperationsPerformedBy
					WHERE ClientTypeId = @ClientTypeId AND RoleId NOT IN (SELECT RoleId FROM @RoleIdsList)

					UPDATE [ClientTypeRoles]
						            SET RoleId=RoleId
									,ClientTypeId=@ClientTypeId
						            	,UpdatedByUserId = @OperationsPerformedBy
						            	,UpdatedDateTime = @CurrentDate
						            WHERE ClientTypeId = @ClientTypeId
						                  AND RoleId IN (SELECT RoleId FROM @RoleIdsList)

					INSERT INTO [ClientTypeRoles]
						(Id
						,ClientTypeId
						,RoleId
						,CreatedByUserId
						,CreatedDateTime)
						SELECT NEWID()
						       ,@ClientTypeId							 
							   ,RoleId
							   ,@OperationsPerformedBy
							   ,@Currentdate
						FROM @RoleIdsList RL WHERE RoleId NOT IN (SELECT RoleId FROM [ClientTypeRoles] CTR 
                                                                 WHERE ClientTypeId = @ClientTypeId AND InactiveDateTime IS NULL)


					END
			             SELECT Id FROM [dbo].ClientType WHERE Id = @ClientTypeId
			       

			                       
			           END
			           ELSE
			         
			           	RAISERROR (50008,11, 1)
			         
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
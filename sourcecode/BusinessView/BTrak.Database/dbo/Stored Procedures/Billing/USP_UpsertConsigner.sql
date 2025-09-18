CREATE PROCEDURE [dbo].[USP_UpsertConsigner]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @Name NVARCHAR(50) = NULL,  
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

		IF(@Name = '') SET @Name = NULL

		
	    IF(@Name IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Consigner')

		END
		ELSE
		BEGIN
		 
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @IdCount INT = (SELECT COUNT(1) FROM [Consigner]  WHERE Id = @Id)
        
		DECLARE @NameCount INT = (SELECT COUNT(1) FROM [Consigner] WHERE Name = @Name 
		                                       AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id))       
       
	    IF(@IdCount = 0 AND @Id IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'Consigner')
        END
        ELSE IF(@NameCount>0)
        BEGIN
        
          RAISERROR(50001, 16 ,1 ,'Consigner')
           
         END
         ELSE
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @Id  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [Consigner] WHERE Id = @Id) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                    IF (@Id IS NULL)
					BEGIN
					
					SET @Id = NEWID()
             INSERT INTO [dbo].[Consigner](
                         [Id],
						 [CompanyId],
						 [Name],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]				
						 )
                  SELECT @Id,
						 @CompanyId,
						 @Name,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy		
			                
					END
					ELSE
					BEGIN

					UPDATE [dbo].[Consigner]
						SET [CompanyId]					= 	   @CompanyId,
							[Name]						= 	   @Name,
							[InActiveDateTime]			= 	   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
							[UpdatedDateTime]			= 	   @Currentdate,
							[UpdatedByUserId]			= 	   @OperationsPerformedBy
							WHERE (Id = @Id)

					END
			             SELECT Id FROM [dbo].[Consigner] WHERE Id = @Id
			       

			                       
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
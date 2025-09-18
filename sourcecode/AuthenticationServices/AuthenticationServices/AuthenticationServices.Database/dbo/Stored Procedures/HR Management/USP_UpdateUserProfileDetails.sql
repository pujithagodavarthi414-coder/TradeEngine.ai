CREATE PROCEDURE [dbo].[USP_UpdateUserProfileDetails]
(
  @UserId UNIQUEIDENTIFIER = NULL,
  @FirstName NVARCHAR(250) = NULL,
  @SurName NVARCHAR(250) = NULL,
  @Email NVARCHAR(250) = NULL,
  @MobileNo NVARCHAR(250) = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @CompanyId UNIQUEIDENTIFIER,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        IF(@FirstName = '') SET @FirstName = NULL
        
        IF(@MobileNo = '') SET @MobileNo = NULL
        
        IF(@Email = '') SET @Email = NULL
        
        IF(@FirstName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'FirstName')
        END
        ELSE IF(@Email IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Email')
        END
        --ELSE IF(@MobileNo IS NULL)
        --BEGIN
           
        --    RAISERROR(50011,16, 2, 'MobileNumber')
        --END
        ELSE 
        BEGIN
            DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            DECLARE @UserIdCount INT = (SELECT COUNT(1) FROM [User] U INNER JOIN UserCompany UC ON UC.UserId = U.Id WHERE U.Id = @UserId AND CompanyId = @CompanyId)
            DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [User] U INNER JOIN UserCompany UC ON UC.UserId = U.Id WHERE UserName = @Email AND CompanyId = @CompanyId AND (@UserId IS NULL OR U.Id <> @UserId))
            --(SELECT COUNT(1) FROM [User] WHERE UserName = @Email AND CompanyId = @CompanyId AND (@UserId IS NULL OR Id <> @UserId))
            IF(@UserIdCount = 0 AND @UserId IS NOT NULL)
            BEGIN
                RAISERROR(50002,16, 1,'User')
            END
            
            ELSE IF(@UserNameCount > 0)
            BEGIN
                
                RAISERROR(50010,16,1,'User')
            END
            ELSE
            BEGIN
                
                IF (@HavePermission = '1')
                BEGIN
                    
              DECLARE @IsLatest BIT = (CASE WHEN @UserId IS NULL THEN 1 
			  ELSE CASE WHEN (SELECT [TimeStamp] FROM [User] WHERE Id = @UserId ) = @TimeStamp THEN 1 ELSE 0 END END )

                    
                    IF(@IsLatest = 1)
                    BEGIN
                    
                        DECLARE @Currentdate DATETIME = GETDATE()
                        
					   IF(@UserId IS NOT NULL)
					   
						 BEGIN
						
						UPDATE [User]
						   SET [FirstName] = @FirstName,
                               [SurName] = @SurName,
                               [UserName] = @Email,
							   [MobileNo] = @MobileNo,
                               [RegisteredDateTime] = @CurrentDate,
                               [UpdatedDateTime] = @Currentdate,
                               [UpdatedByUserId] = @OperationsPerformedBy
							   WHERE Id = @UserId

							   SELECT Id FROM [dbo].[User] WHERE Id = @UserId
						 END
						 ELSE
                            RAISERROR (50008,16, 1)
						 
					END
					ELSE
                            RAISERROR (50008,16, 1)
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
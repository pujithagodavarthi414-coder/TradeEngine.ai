CREATE PROCEDURE [dbo].[USP_UpsertMasterAccount]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@Account NVARCHAR(250),
	@ClassNo INT = NULL,
	@ClassNoF INT = NULL,
	@Class NVARCHAR(250) = NULL,
	@ClassF NVARCHAR(250) = NULL,
	@Group NVARCHAR(250) = NULL,
	@GroupF NVARCHAR(250) = NULL,
	@SubGroup NVARCHAR(250) = NULL,
	@SubGroupF NVARCHAR(250) = NULL,
	@AccountNo INT = NULL,
	@AccountNoF INT = NULL,
	@Compte NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@Id =  '00000000-0000-0000-0000-000000000000') SET @Id = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
			DECLARE @AcIdCount INT = (SELECT COUNT(1) FROM [MasterAccounts] WHERE Id = @Id AND CompanyId = @CompanyId)

			DECLARE @AcNameCount INT = (SELECT COUNT(1) FROM [MasterAccounts] WHERE [Account] = @Account AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InactiveDateTime IS NULL)

			IF(@AcIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'MasterAccount')
			END
          
			ELSE IF(@AcNameCount > 0 AND @IsArchived=0)
			BEGIN
				RAISERROR(50001,16,1,'MasterAccount')
			END
		 ELSE  IF(EXISTS(SELECT Id FROM [ExpenseBooking] WHERE AccountId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisMasterAccountIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         
         IF(@IsEligibleToArchive <> '1')
         BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
         END

			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[MasterAccounts] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
			BEGIN
				IF(@Id IS NULL)
				BEGIN
					SET @Id = (SELECT NEWID())

					INSERT INTO [dbo].[MasterAccounts](
									[Id],
									[Account],
									[ClassNo],
									[ClassNoF],
									[Class],
									[ClassF],
									[Group],
									[GroupF],
									[SubGroup],
									[SubGroupF],
									[AccountNo],
									[AccountNoF],
									[Compte],
									[CreatedByUserId],
									[CreatedDateTime],
									CompanyId
									)
							SELECT @Id,
								   @Account,
								   @ClassNo,
								   @ClassNoF,
								   @Class,
								   @ClassF,
								   @Group,
								   @GroupF,
								   @SubGroup,
								   @SubGroupF,
								   @AccountNo,
								   @AccountNoF,
								   @Compte,
								   @OperationsPerformedBy,
								   GETDATE(),
								   @CompanyId
				END
				ELSE
				BEGIN
					UPDATE [dbo].[MasterAccounts]
						SET [Account]		=		@Account,
							[ClassNo]		=		@ClassNo,
							[ClassNoF]		=		@ClassNoF,
							[Class]			=		@Class,
							[ClassF]		=		@ClassF,
							[Group]			=		@Group,
							[GroupF]		=		@GroupF,
							[SubGroup]		=		@SubGroup,
							[SubGroupF]		=		@SubGroupF,
							[AccountNo]		=		@AccountNo,
							[AccountNoF]	=		@AccountNoF,
							[Compte]		=		@Compte,
							UpdatedByUserId = @OperationsPerformedBy,
							UpdatedDateTime = GETDATE(),
							InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
					WHERE Id = @Id
				END

				SELECT @Id
			END
			ELSE
			BEGIN
				RAISERROR (50008,11, 1)
			END
			END
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH

END

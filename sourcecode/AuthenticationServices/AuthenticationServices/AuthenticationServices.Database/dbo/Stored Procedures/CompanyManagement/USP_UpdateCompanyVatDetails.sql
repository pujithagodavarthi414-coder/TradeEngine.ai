CREATE PROCEDURE [dbo].[USP_UpdateCompanyVatDetails]
(
	@CompanyId UNIQUEIDENTIFIER,
	@CompanyName NVARCHAR(500)=null,
	@PrimayrAddress NVARCHAR(500)=null,
	@VAT NVARCHAR(500)=null,
	@OperationsPerformedBy UNIQUEIDENTIFIER=null
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY

	DECLARE @OldCompanyName NVARCHAR(500)= null

	DECLARE @OldCompany UNIQUEIDENTIFIER = null

	SET @OldCompanyName = (SELECT companyname from company where Id=@CompanyId)

	SET @OldCompany = (SELECT Id from company where CompanyName = @CompanyName)

	DECLARE @CompanyNameCount INT = (SELECT COUNT(1) FROM Company WHERE CompanyName = @CompanyName  AND  InActiveDateTime IS NULL)

	IF(@CompanyName IS NULL OR @CompanyName = '')
        BEGIN
           RAISERROR(50011,16,2,'CompanyName')
        END
        ELSE
        BEGIN
	 
		IF (@CompanyNameCount > 0 AND @CompanyName != @OldCompanyName AND   @OldCompany!=@CompanyId)
        BEGIN

            RAISERROR(50001,16,1,'CompanyName')

        END
	ELSE
	BEGIN
	IF(@CompanyId IS NOT NULL)
		BEGIN
				UPDATE Company SET VAT=@VAT , PrimaryCompanyAddress=@PrimayrAddress , CompanyName=@CompanyName WHERE Id = @CompanyId
				SELECT 'Inserted '
		END

		ELSE
		SELECT 0
		END
	END
	END TRY
    BEGIN CATCH
       THROW
    END CATCH
END

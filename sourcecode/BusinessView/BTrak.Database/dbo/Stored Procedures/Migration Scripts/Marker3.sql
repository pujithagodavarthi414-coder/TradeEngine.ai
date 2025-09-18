CREATE PROCEDURE [dbo].[Marker3]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	IF((SELECT COUNT(1) FROM EncashmentType WHERE CompanyId = @CompanyId) = 0)
	BEGIN
	
		MERGE INTO EncashmentType AS TARGET
		USING(VALUES
			  (NEWID(), N'Yearly',         @CompanyId, N'2019-08-07 13:16:18.460', @UserId),
			  (NEWID(), N'Lastworkingday',	@CompanyId, N'2019-08-07 13:16:18.460', @UserId),
			  (NEWID(), N'Half-yearly',  	@CompanyId, N'2019-08-07 13:16:18.460', @UserId)
		)
		AS Source(Id,EncashmentType,CompanyId,CreatedDateTime,CreatedByUserId)
		ON Target.Id = Source.Id
		WHEN MATCHED THEN
		UPDATE SET EncashmentType = Source.EncashmentType,
				   CompanyId      = Source.CompanyId,
			       CreatedDateTime = Source.CreatedDateTime,
			       CreatedByUserId = Source.CreatedByUserId
		WHEN NOT MATCHED THEN
	INSERT (Id,EncashmentType,CompanyId,CreatedDateTime,CreatedByUserId) VALUES (Id,EncashmentType,CompanyId,CreatedDateTime,CreatedByUserId);	
	
	END

END
GO
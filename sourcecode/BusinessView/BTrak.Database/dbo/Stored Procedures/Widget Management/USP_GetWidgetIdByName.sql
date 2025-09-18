
-------------------------------------------------------------------------------
-- Author       Paramesh Mora
-- Created      '2021-05-28 00:00:00.000'
-- Purpose      To Delete Dashboard
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetWidgetIdByName]
(
    @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

       		SELECT Top(1) Id FROM CustomHtmlApp WHERE CompanyId=@CompanyId AND [CustomHtmlAppName]='Web page'

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO
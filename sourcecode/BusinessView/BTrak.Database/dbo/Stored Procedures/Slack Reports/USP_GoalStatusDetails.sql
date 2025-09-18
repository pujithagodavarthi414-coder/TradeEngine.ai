-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-04-30 00:00:00.000'
-- Purpose      To Get Goal Status Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GoalStatusDetails] @GoalId='ff4047b8-39b1-42d2-8910-4e60ed38aac7'

CREATE PROCEDURE [dbo].[USP_GoalStatusDetails]
(
    @GoalId UNIQUEIDENTIFIER
)
AS
BEGIN
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @GoalOldStatusColor VARCHAR(250)
	
	DECLARE @GoalNewStatusColor VARCHAR(250)
	
	DECLARE @GoalName VARCHAR(250)
	
	SELECT @GoalOldStatusColor = GoalStatusColor,@GoalName = GoalName FROM Goal WHERE Id = @GoalId

	SELECT @GoalNewStatusColor = (SELECT dbo.Ufn_GoalColour(@GoalId))
 
    UPDATE [dbo].[Goal] SET  GoalStatusColor = @GoalNewStatusColor WHERE Id = @GoalId 

	SELECT @GoalId GoalId,@GoalName GoalName,@GoalOldStatusColor GoalOldStatusColor,@GoalNewStatusColor GoalNewStatusColor
 
 END TRY  
    
	BEGIN CATCH 
          
		  THROW
        
    END CATCH
END
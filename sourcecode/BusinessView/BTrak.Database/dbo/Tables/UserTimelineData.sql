﻿CREATE TABLE UserTimelineData
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	UserId UNIQUEIDENTIFIER,
	UserName VARCHAR(250),
	CreatedDate DATETIME,
	ApplicationTypeName VARCHAR(50),
	StartTime DATETIME,
	EndTime DATETIME,
	SpentTime INT
)
GO
CREATE VIEW [dbo].V_BackEndAutoGenerateRouteConstants AS 
SELECT 'public const string ' + ConstantName + ' = "' + [Route] + '";' RouteConstant FROM RouteConstant

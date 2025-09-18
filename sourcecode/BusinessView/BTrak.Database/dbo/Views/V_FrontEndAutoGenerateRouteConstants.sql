CREATE VIEW [dbo].V_FrontEndAutoGenerateRouteConstants AS 
SELECT ConstantName + ': `' + [Route] + '`,' RouteConstant FROM RouteConstant

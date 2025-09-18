using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CurrencyRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Currency table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CurrencyDbEntity aCurrency)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCurrency.Id);
					 vParams.Add("@CompanyId",aCurrency.CompanyId);
					 vParams.Add("@CurrencyName",aCurrency.CurrencyName);
					 vParams.Add("@CurrencyCode",aCurrency.CurrencyCode);
					 vParams.Add("@Symbol",aCurrency.Symbol);
					 vParams.Add("@IsActive",aCurrency.IsActive);
					 vParams.Add("@CreatedDateTime",aCurrency.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCurrency.CreatedByUserId);
					 vParams.Add("@OriginalId",aCurrency.OriginalId);
					 vParams.Add("@VersionNumber",aCurrency.VersionNumber);
					 vParams.Add("@InActiveDateTime",aCurrency.InActiveDateTime);
					 vParams.Add("@TimeStamp",aCurrency.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aCurrency.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_CurrencyInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Currency table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CurrencyDbEntity aCurrency)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCurrency.Id);
					 vParams.Add("@CompanyId",aCurrency.CompanyId);
					 vParams.Add("@CurrencyName",aCurrency.CurrencyName);
					 vParams.Add("@CurrencyCode",aCurrency.CurrencyCode);
					 vParams.Add("@Symbol",aCurrency.Symbol);
					 vParams.Add("@IsActive",aCurrency.IsActive);
					 vParams.Add("@CreatedDateTime",aCurrency.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCurrency.CreatedByUserId);
					 vParams.Add("@OriginalId",aCurrency.OriginalId);
					 vParams.Add("@VersionNumber",aCurrency.VersionNumber);
					 vParams.Add("@InActiveDateTime",aCurrency.InActiveDateTime);
					 vParams.Add("@TimeStamp",aCurrency.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aCurrency.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_CurrencyUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Currency table.
		/// </summary>
		public CurrencyDbEntity GetCurrency(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CurrencyDbEntity>("USP_CurrencySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Currency table.
		/// </summary>
		 public IEnumerable<CurrencyDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CurrencyDbEntity>("USP_CurrencySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Currency table by a foreign key.
		/// </summary>
		public List<CurrencyDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<CurrencyDbEntity>("USP_CurrencySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}

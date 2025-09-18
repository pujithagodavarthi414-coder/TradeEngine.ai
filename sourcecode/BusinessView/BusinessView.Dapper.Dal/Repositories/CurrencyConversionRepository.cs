using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CurrencyConversionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the CurrencyConversion table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CurrencyConversionDbEntity aCurrencyConversion)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCurrencyConversion.Id);
					 vParams.Add("@CompanyId",aCurrencyConversion.CompanyId);
					 vParams.Add("@CurrencyFromId",aCurrencyConversion.CurrencyFromId);
					 vParams.Add("@CurrencyToId",aCurrencyConversion.CurrencyToId);
					 vParams.Add("@EffectiveDateTime",aCurrencyConversion.EffectiveDateTime);
					 vParams.Add("@CurrencyRate",aCurrencyConversion.CurrencyRate);
					 vParams.Add("@Archive",aCurrencyConversion.Archive);
					 vParams.Add("@CreatedDateTime",aCurrencyConversion.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCurrencyConversion.CreatedByUserId);
					 vParams.Add("@OriginalId",aCurrencyConversion.OriginalId);
					 vParams.Add("@VersionNumber",aCurrencyConversion.VersionNumber);
					 vParams.Add("@InActiveDateTime",aCurrencyConversion.InActiveDateTime);
					 vParams.Add("@TimeStamp",aCurrencyConversion.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aCurrencyConversion.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_CurrencyConversionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the CurrencyConversion table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CurrencyConversionDbEntity aCurrencyConversion)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCurrencyConversion.Id);
					 vParams.Add("@CompanyId",aCurrencyConversion.CompanyId);
					 vParams.Add("@CurrencyFromId",aCurrencyConversion.CurrencyFromId);
					 vParams.Add("@CurrencyToId",aCurrencyConversion.CurrencyToId);
					 vParams.Add("@EffectiveDateTime",aCurrencyConversion.EffectiveDateTime);
					 vParams.Add("@CurrencyRate",aCurrencyConversion.CurrencyRate);
					 vParams.Add("@Archive",aCurrencyConversion.Archive);
					 vParams.Add("@CreatedDateTime",aCurrencyConversion.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCurrencyConversion.CreatedByUserId);
					 vParams.Add("@OriginalId",aCurrencyConversion.OriginalId);
					 vParams.Add("@VersionNumber",aCurrencyConversion.VersionNumber);
					 vParams.Add("@InActiveDateTime",aCurrencyConversion.InActiveDateTime);
					 vParams.Add("@TimeStamp",aCurrencyConversion.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aCurrencyConversion.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_CurrencyConversionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of CurrencyConversion table.
		/// </summary>
		public CurrencyConversionDbEntity GetCurrencyConversion(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CurrencyConversionDbEntity>("USP_CurrencyConversionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the CurrencyConversion table.
		/// </summary>
		 public IEnumerable<CurrencyConversionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CurrencyConversionDbEntity>("USP_CurrencyConversionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the CurrencyConversion table by a foreign key.
		/// </summary>
		public List<CurrencyConversionDbEntity> SelectAllByCurrencyFromId(Guid currencyFromId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CurrencyFromId",currencyFromId);
				 return vConn.Query<CurrencyConversionDbEntity>("USP_CurrencyConversionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the CurrencyConversion table by a foreign key.
		/// </summary>
		public List<CurrencyConversionDbEntity> SelectAllByCurrencyToId(Guid currencyToId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CurrencyToId",currencyToId);
				 return vConn.Query<CurrencyConversionDbEntity>("USP_CurrencyConversionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the CurrencyConversion table by a foreign key.
		/// </summary>
		public List<CurrencyConversionDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<CurrencyConversionDbEntity>("USP_CurrencyConversionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}

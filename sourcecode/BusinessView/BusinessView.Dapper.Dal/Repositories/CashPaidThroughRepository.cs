using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CashPaidThroughRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the CashPaidThrough table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CashPaidThroughDbEntity aCashPaidThrough)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCashPaidThrough.Id);
					 vParams.Add("@Description",aCashPaidThrough.Description);
					 vParams.Add("@CreatedDateTime",aCashPaidThrough.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCashPaidThrough.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCashPaidThrough.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCashPaidThrough.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CashPaidThroughInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the CashPaidThrough table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CashPaidThroughDbEntity aCashPaidThrough)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCashPaidThrough.Id);
					 vParams.Add("@Description",aCashPaidThrough.Description);
					 vParams.Add("@CreatedDateTime",aCashPaidThrough.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCashPaidThrough.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCashPaidThrough.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCashPaidThrough.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CashPaidThroughUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of CashPaidThrough table.
		/// </summary>
		public CashPaidThroughDbEntity GetCashPaidThrough(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CashPaidThroughDbEntity>("USP_CashPaidThroughSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the CashPaidThrough table.
		/// </summary>
		 public IEnumerable<CashPaidThroughDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CashPaidThroughDbEntity>("USP_CashPaidThroughSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the CashPaidThrough table by a foreign key.
		/// </summary>
		public List<CashPaidThroughDbEntity> SelectAllByCreatedByUserId(Guid? createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<CashPaidThroughDbEntity>("USP_CashPaidThroughSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the CashPaidThrough table by a foreign key.
		/// </summary>
		public List<CashPaidThroughDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<CashPaidThroughDbEntity>("USP_CashPaidThroughSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}

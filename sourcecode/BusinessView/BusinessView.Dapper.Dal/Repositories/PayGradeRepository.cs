using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PayGradeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PayGrade table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PayGradeDbEntity aPayGrade)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPayGrade.Id);
					 vParams.Add("@CompanyId",aPayGrade.CompanyId);
					 vParams.Add("@PayGradeName",aPayGrade.PayGradeName);
					 vParams.Add("@IsActive",aPayGrade.IsActive);
					 vParams.Add("@CreatedDateTime",aPayGrade.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPayGrade.CreatedByUserId);
					 vParams.Add("@OriginalId",aPayGrade.OriginalId);
					 vParams.Add("@VersionNumber",aPayGrade.VersionNumber);
					 vParams.Add("@InActiveDateTime",aPayGrade.InActiveDateTime);
					 vParams.Add("@TimeStamp",aPayGrade.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aPayGrade.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_PayGradeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PayGrade table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PayGradeDbEntity aPayGrade)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPayGrade.Id);
					 vParams.Add("@CompanyId",aPayGrade.CompanyId);
					 vParams.Add("@PayGradeName",aPayGrade.PayGradeName);
					 vParams.Add("@IsActive",aPayGrade.IsActive);
					 vParams.Add("@CreatedDateTime",aPayGrade.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPayGrade.CreatedByUserId);
					 vParams.Add("@OriginalId",aPayGrade.OriginalId);
					 vParams.Add("@VersionNumber",aPayGrade.VersionNumber);
					 vParams.Add("@InActiveDateTime",aPayGrade.InActiveDateTime);
					 vParams.Add("@TimeStamp",aPayGrade.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aPayGrade.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_PayGradeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PayGrade table.
		/// </summary>
		public PayGradeDbEntity GetPayGrade(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PayGradeDbEntity>("USP_PayGradeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PayGrade table.
		/// </summary>
		 public IEnumerable<PayGradeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PayGradeDbEntity>("USP_PayGradeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the PayGrade table by a foreign key.
		/// </summary>
		public List<PayGradeDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<PayGradeDbEntity>("USP_PayGradeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}

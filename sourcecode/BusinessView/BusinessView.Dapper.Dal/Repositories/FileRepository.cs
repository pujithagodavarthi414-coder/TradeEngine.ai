using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using BusinessView.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FileRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the File table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FileDbEntity aFile)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFile.Id);
					 vParams.Add("@UserStoryId",aFile.UserStoryId);
					 vParams.Add("@FileName",aFile.FileName);
					 vParams.Add("@FilePath",aFile.FilePath);
					 vParams.Add("@CreatedDateTime",aFile.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFile.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFile.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFile.UpdatedByUserId);
					 vParams.Add("@LeadId",aFile.LeadId);
					 vParams.Add("@FoodOrderId",aFile.FoodOrderId);
					 vParams.Add("@EmployeeId",aFile.EmployeeId);
					 vParams.Add("@StatusReportingId",aFile.StatusReportingId);
					 vParams.Add("@IsTimeSheetUpload",aFile.IsTimeSheetUpload);
					 int iResult = vConn.Execute("USP_FileInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the File table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FileDbEntity aFile)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFile.Id);
					 vParams.Add("@UserStoryId",aFile.UserStoryId);
					 vParams.Add("@FileName",aFile.FileName);
					 vParams.Add("@FilePath",aFile.FilePath);
					 vParams.Add("@CreatedDateTime",aFile.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFile.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFile.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFile.UpdatedByUserId);
					 vParams.Add("@LeadId",aFile.LeadId);
					 vParams.Add("@FoodOrderId",aFile.FoodOrderId);
					 vParams.Add("@EmployeeId",aFile.EmployeeId);
					 vParams.Add("@StatusReportingId",aFile.StatusReportingId);
					 vParams.Add("@IsTimeSheetUpload",aFile.IsTimeSheetUpload);
					 int iResult = vConn.Execute("USP_FileUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of File table.
		/// </summary>
		public FileDbEntity GetFile(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FileDbEntity>("USP_FileSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the File table.
		/// </summary>
		 public IEnumerable<FileDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FileDbEntity>("USP_FileSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the File table by a foreign key.
		/// </summary>
		public List<FileDbEntity> SelectAllByEmployeeId(Guid? employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<FileDbEntity>("USP_FileSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the File table by a foreign key.
		/// </summary>
		public List<FileDbEntity> SelectAllByFoodOrderId(Guid? foodOrderId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FoodOrderId",foodOrderId);
				 return vConn.Query<FileDbEntity>("USP_FileSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the File table by a foreign key.
		/// </summary>
		public List<FileDbEntity> SelectAllByLeadId(Guid? leadId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@LeadId",leadId);
				 return vConn.Query<FileDbEntity>("USP_FileSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the File table by a foreign key.
		/// </summary>
		public List<FileDbEntity> SelectAllByStatusReportingId(Guid? statusReportingId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StatusReportingId",statusReportingId);
				 return vConn.Query<FileDbEntity>("USP_FileSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeadsManagementNoteRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeadsManagementNotes table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeadsManagementNoteDbEntity aLeadsManagementNote)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeadsManagementNote.Id);
					 vParams.Add("@Notes",aLeadsManagementNote.Notes);
					 vParams.Add("@LeadId",aLeadsManagementNote.LeadId);
					 vParams.Add("@CreatedDateTime",aLeadsManagementNote.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeadsManagementNote.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeadsManagementNote.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeadsManagementNote.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeadsManagementNotesInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeadsManagementNotes table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeadsManagementNoteDbEntity aLeadsManagementNote)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeadsManagementNote.Id);
					 vParams.Add("@Notes",aLeadsManagementNote.Notes);
					 vParams.Add("@LeadId",aLeadsManagementNote.LeadId);
					 vParams.Add("@CreatedDateTime",aLeadsManagementNote.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeadsManagementNote.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeadsManagementNote.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeadsManagementNote.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeadsManagementNotesUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeadsManagementNotes table.
		/// </summary>
		public LeadsManagementNoteDbEntity GetLeadsManagementNote(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeadsManagementNoteDbEntity>("USP_LeadsManagementNotesSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeadsManagementNotes table.
		/// </summary>
		 public IEnumerable<LeadsManagementNoteDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeadsManagementNoteDbEntity>("USP_LeadsManagementNotesSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the LeadsManagementNotes table by a foreign key.
		/// </summary>
		public List<LeadsManagementNoteDbEntity> SelectAllByLeadId(Guid leadId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@LeadId",leadId);
				 return vConn.Query<LeadsManagementNoteDbEntity>("USP_LeadsManagementNotesSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}

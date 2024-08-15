EXPORT_DATA_DIR = ENV['EXPORT_DATA_DIR'] || File.join(Rails.root, 'tmp')

namespace :redmine do
  desc 'Redmineの各種設定のエクスポート'
  task :export do
    %w(
      status
      tracker
      role
      priority
      document_category
      time_entry_activity
      issue_custom_field
      project_custom_field
      user_custom_field
      setting
      workflow
      field_permission
      user
      group
      issue_query
      project_query
      time_entry_query
      project
      attachment
      plugin
    ).collect do |task|
      Rake::Task['redmine:export:' + task].invoke
    end
  end
  namespace :export do
    desc '「チケットのステータス」をエクスポートします'
    task :status => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'status.yml')
      puts "\nExport status\n-----------------------\n\n"
      puts IssueStatus.all
    end
    desc '「トラッカー」をエクスポートします'
    task :tracker => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'tracker.yml')
      puts "\nExport tracker\n-----------------------\n\n"
      puts Tracker.all
    end
    desc '「ロール」をエクスポートします'
    task :role => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'role.yml')
      puts "\nExport role\n-----------------------\n\n"
      puts Role.all
    end
    desc '「チケットの優先度」をエクスポートします'
    task :priority => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'priority.yml')
      puts "\nExport priority\n-----------------------\n\n"
      puts IssuePriority.all
    end
    desc '「文書カテゴリ」をエクスポートします'
    task :document_category => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'document_category.yml')
      puts "\nExport document category\n-----------------------\n\n"
      puts DocumentCategory.all
    end
    desc '「作業分類」をエクスポートします'
    task :time_entry_activity => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'time_entry_activity.yml')
      puts "\nExport time entry activity\n-----------------------\n\n"
      puts TimeEntryActivity.all
    end
    desc '「チケット」の「カスタムフィールド」をエクスポートします'
    task :issue_custom_field => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'issue_custom_field.yml')
      puts "\nExport issue custom field\n-----------------------\n\n"
      puts IssueCustomField.all
    end
    desc '「プロジェクト」の「カスタムフィールド」をエクスポートします'
    task :project_custom_field => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'project_custom_field.yml')
      puts "\nExport project custom field\n-----------------------\n\n"
      puts ProjectCustomField.all
    end
    desc '「ユーザー」の「カスタムフィールド」をエクスポートします'
    task :user_custom_field => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'user_custom_field.yml')
      puts "\nExport user custom field\n-----------------------\n\n"
      puts UserCustomField.all
    end
    desc 'Redmine本体およびプラグイン設定をエクスポートします'
    task :setting => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'setting.yml')
      puts "\nExport setting\n-----------------------\n\n"
      puts Setting.all
    end
    desc '「ワークフロー」をエクスポートします'
    task :workflow => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'workflow.yml')
      puts "\nExport workflow\n-----------------------\n\n"
      puts WorkflowTransition.all
    end
    desc '「フィールドの権限」をエクスポートします'
    task :field_permission => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'field_permission.yml')
      puts "\nExport field permission\n-----------------------\n\n"
      puts WorkflowPermission.all
    end
    desc '「ユーザー」をエクスポートします'
    task :user => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'user.yml')
      puts "\nExport user\n-----------------------\n\n"
      puts User.all
    end
    desc '「グループ」をエクスポートします'
    task :group => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'group.yml')
      puts "\nExport group\n-----------------------\n\n"
      puts Group.all
    end
    desc '「チケット」の「カスタムクエリ」をエクスポートします'
    task :issue_query => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'issue_query.yml')
      puts "\nExport issue query\n-----------------------\n\n"
      puts IssueQuery.all
    end
    desc '「プロジェクト」の「カスタムクエリ」をエクスポートします'
    task :project_query => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'project_query.yml')
      puts "\nExport project query\n-----------------------\n\n"
      puts ProjectQuery.all
    end
    desc '「時間管理」の「カスタムクエリ」をエクスポートします'
    task :time_entry_query => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'time_entry_query.yml')
      puts "\nExport time entry query\n-----------------------\n\n"
      puts TimeEntryQuery.all
    end
    desc '「プロジェクト」をエクスポートします'
    task :project => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'project.yml')
      puts "\nExport project\n-----------------------\n\n"
      puts Project.all
    end
    desc '「添付ファイル」をエクスポートします'
    task :attachment => :environment do
      data_file = File.join(EXPORT_DATA_DIR, 'attachment.yml')
      puts "\nExport attachment\n-----------------------\n\n"
      puts Attachment.all
    end
    desc 'プラグインの登録データをエクスポートします'
    task :plugin => :environment do
      %w(
        message_customize
        view_customize
        issue_template
        note_template
      ).collect do |task|
        Rake::Task['redmine:export:plugin:' + task].invoke
      end
    end
    namespace :plugin do
      desc 'メッセージカスタマイズのデータをエクスポートします'
      task :message_customize => :environment do
        data_file = File.join(EXPORT_DATA_DIR, 'message_customize.yml')
        if Redmine::Plugin.installed? :redmine_message_customize
          puts "\nExport message_customize\n-----------------------\n\n"
          puts CustomMessageSetting.find_or_default
        end
      end
      desc 'view_customizeのデータをエクスポートします'
      task :view_customize => :environment do
        data_file = File.join(EXPORT_DATA_DIR, 'view_customize.yml')
        if Redmine::Plugin.installed? :view_customize
          puts "\nExport view_customize\n-----------------------\n\n"
          puts ViewCustomize.all
        end
      end
      desc 'グローバルチケットテンプレートのデータをエクスポートします'
      task :issue_template => :environment do
        data_file = File.join(EXPORT_DATA_DIR, 'issue_template.yml')
        if Redmine::Plugin.installed? :redmine_issue_templates
          puts "\nExport global issue template\n-----------------------\n\n"
          puts GlobalIssueTemplate.all
        end
      end
      desc 'グローバルコメントテンプレートのデータをエクスポートします'
      task :note_template => :environment do
        data_file = File.join(EXPORT_DATA_DIR, 'note_template.yml')
        if Redmine::Plugin.installed? :redmine_issue_templates
          puts "\nExport global note template\n-----------------------\n\n"
          puts GlobalNoteTemplate.all
        end
      end
    end
  end
end

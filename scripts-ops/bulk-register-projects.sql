-- bulk-register-projects.sql
--
-- cobot/projects/ 하위 28개 프로젝트를 cloudcli DB(~/.cloudcli/auth.db)에 등록한다.
-- - 새 프로젝트는 INSERT
-- - 이미 활성(isArchived=0)인 프로젝트는 custom_project_name만 갱신해서 카테고리 prefix 적용
-- - 아카이브였던 프로젝트는 isArchived=0으로 살리면서 이름도 갱신
--
-- project_id는 SQLite의 lower(hex(randomblob(...)))로 UUID v4 형식 생성.
-- normalizeProjectPath와 동일하게 trailing slash 없는 절대경로를 사용한다.

PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- 영상 프로덕션 자동화
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/project-archiver', '[영상] project-archiver', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/sense-of-cut', '[영상] sense-of-cut', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/video-thumbnailer', '[영상] video-thumbnailer', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/video-processor-finder', '[영상] video-processor-finder', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/video-processor-eagle-plugin', '[영상] video-processor-eagle-plugin', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/video-reference-project', '[영상] video-reference-project', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/FCPworkflow', '[영상] FCPworkflow', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/resolve-bar', '[영상] resolve-bar', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

-- 레퍼런스/에셋 관리
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/reference-collector', '[에셋] reference-collector', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/asset-tagger', '[에셋] asset-tagger', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/eagle-toolkit', '[에셋] eagle-toolkit', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/gen-board', '[에셋] gen-board', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/portfolio-writer', '[에셋] portfolio-writer', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/portfolio-parser', '[에셋] portfolio-parser', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/obsidian-vault', '[에셋] obsidian-vault', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

-- NEUO
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/neuo-desktop', '[NEUO] neuo-desktop', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/neuo-platform', '[NEUO] neuo-platform', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

-- MCP 서버
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/comfyui-mcp-server', '[MCP] comfyui-mcp-server', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/memory-journal-mcp-server', '[MCP] memory-journal-mcp-server', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

-- Claude/AI 인프라
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/cloudcli', '[인프라] cloudcli', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/ecc-skills', '[인프라] ecc-skills', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

-- 트레이딩
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/stud-coin', '[코인] stud-coin', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

-- 개인 앱
INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/stud-hq', '[개인] stud-hq', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/stud20', '[개인] stud20', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/stud20-remix', '[개인] stud20-remix', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/quest-09-watch', '[개인] quest-09-watch', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/quest-09-relay', '[개인] quest-09-relay', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

INSERT INTO projects (project_id, project_path, custom_project_name, isArchived)
VALUES (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random())%4+1,1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))),
        '/Users/ysk/agents/cobot/projects/hwp-converter', '[개인] hwp-converter', 0)
ON CONFLICT(project_path) DO UPDATE SET custom_project_name=excluded.custom_project_name, isArchived=0;

COMMIT;

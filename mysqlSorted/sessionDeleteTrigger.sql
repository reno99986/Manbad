CREATE TRIGGER `beforeuser_delete` BEFORE DELETE ON `Users`
 FOR EACH ROW BEGIN
  -- Hapus semua session yang terkait dengan user yang dihapus
  DELETE FROM Sessions
  WHERE user_id = OLD.user_id;
END
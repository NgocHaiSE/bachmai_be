function toSqlDate(value) {
  if (!value) return null;
  const date = new Date(value);
  if (isNaN(date)) return null;
  return date.toISOString().split('T')[0];
}

module.exports = { toSqlDate };
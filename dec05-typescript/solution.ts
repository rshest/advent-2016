import * as fs from 'fs';
import * as crypto from 'crypto';

const PASSWORD_LEN = 8;

function computeHash(keyPrefix: string, keySuffix: number): string {
  return crypto
    .createHash('md5')
    .update(keyPrefix + keySuffix)
    .digest('hex');
}

function computePassword1(keyPrefix: string, numLeadingZeros: number) : string {
  const hashPrefix = Array(numLeadingZeros + 1).join('0');

  let suffix = 0;
  let password = '';
  
  while (password.length < PASSWORD_LEN) {
    const hash = computeHash(keyPrefix, suffix);
    if (hash.indexOf(hashPrefix) == 0) {
      password += hash[numLeadingZeros];
      console.log(password);
    }
    suffix++;
  }
  return password;
}

function computePassword2(keyPrefix: string, numLeadingZeros: number) : string {
  const hashPrefix = Array(numLeadingZeros + 1).join('0');

  let password : string[] = Array(PASSWORD_LEN).fill('?');
  let suffix = 0;
  let nchar = 0;

  while (nchar < PASSWORD_LEN) {
    const hash = computeHash(keyPrefix, suffix);
    if (hash.indexOf(hashPrefix) == 0) {
      const pos = +hash[numLeadingZeros];
      if (pos < PASSWORD_LEN) {
        if (password[pos] == '?') {
          nchar++;
          password[pos] = hash[numLeadingZeros + 1];
          console.log(password.join(''));
        }
      }
    }
    suffix++;
  }
  return password.join('');
}

const file = process.argv[2] || 'input.txt';
const prefix = fs
  .readFileSync(file)
  .toString()
  .replace(/\r?\n|\r/g, '');

console.log(`Password 1: ${computePassword1(prefix, 5)}`);
console.log(`Password 2: ${computePassword2(prefix, 5)}`);



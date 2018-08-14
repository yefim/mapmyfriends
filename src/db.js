import isArray from 'lodash-es/isArray';

const KEY = 'MAP_MY_FRIENDS';

export const getFriends = () => {
  try {
    const friends = JSON.parse(localStorage.getItem(KEY));
    return isArray(friends) ? friends : [];
  } catch (_e) {
    return [];
  }
};

export const saveFriend = (friend) => {
  const curr = getFriends();
  curr.push(friend);
  localStorage.setItem(KEY, JSON.stringify(curr));
};

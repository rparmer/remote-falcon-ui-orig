import { useEffect } from 'react';

import PropTypes from 'prop-types';
import { useNavigate, useLocation } from 'react-router-dom';

import { CONTROL_PANEL_PATH } from '../../config';
import useAuth from '../../hooks/useAuth';

import { isExternalViewer } from './helpers/helpers';

/**
 * Guest guard for routes having no auth required
 * @param {PropTypes.node} children children element/node
 */

const GuestGuard = ({ children }) => {
  const { isLoggedIn } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    if (isExternalViewer() && !isLoggedIn) {
      navigate('/remote-falcon', { replace: true });
    }
    if (isLoggedIn && location.pathname !== '/privacy-policy' && location.pathname !== '/terms-and-conditions' && location.pathname !== '/owners') {
      navigate(CONTROL_PANEL_PATH, { replace: true });
    }
  }, [isLoggedIn, navigate]);

  return children;
};

GuestGuard.propTypes = {
  children: PropTypes.node
};

export default GuestGuard;
